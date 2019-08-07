module Extensions
  # Override division -- should not do it, but use split_between
  def /(*_params)
    raise "Division of money NOT allowed - use 'split_between' to avoid rounding errors"
  end

  # Split the money between the specified number - and return an array of money
  # Remainder in splits are given to the highest value e.g.
  # $2.00 splits [40, 81, 40] into [49, 102, 49]
  # $1.01 splits [ 1,  1,  1] into [35,  33, 33]
  def split_between(params)
    # if just a number is passed in, then money is split equally
    if params.is_a?(Integer)
      divisor = params
      raise ArgumentError, 'Can only split up over a positive number' if divisor < 1

      rounded_split = lossy_divide(divisor)
      results       = Array.new(divisor, rounded_split) # Create with 'divisor' num elements

      # if an array of monies is passed in, then split in proportions
    elsif params.is_a?(Array)

      raise ArgumentError, 'Can only split up over at least one ration' if params.empty? && !zero?

      results = params.map { |p| p.is_a?(::Money) ? p.cents : p }

      total = results.inject(:+)
      if total.zero?
        return Array.new(results.size, ::Money.new(0)) if zero?

        raise ArgumentError, "Total of ratios should not be zero! You sent in: #{params.inspect}"
      end

      results.map! do |ratio|
        ::Money.new((cents * (ratio.to_f / total)).round)
      end
    else
      raise 'Either a Integer or array has to be passed in for splitting money'
    end

    # Distribute rounding to max absolute to avoid a $0 amount getting the rounding
    biggest_value_index = results.index(results.max_by(&:abs))
    results[biggest_value_index] += self - results.total_money

    results
  end

  DEFAULT_FORMAT_RULES = [:html_wrap].freeze
  # Money's default formatted is not flexible enough
  #  - HTML Wrap is simplier
  def format(*rules)
    rules = rules.empty? ? DEFAULT_FORMAT_RULES.dup : rules.flatten

    options = {}
    rules.each do |rule|
      options = rule if rule.is_a? Hash
    end

    html_wrap = rules.include?(:html_wrap)

    options[:delimiter] ||= ','
    options[:separator] ||= '.'

    ''.tap do |formatted|
      formatted << "<span class=\"money #{direction_class}\">" if html_wrap

      rules << :signed if cents < 0

      if rules.include?(:signed)
        formatted << if cents > 0
                       '+'
                     elsif cents < 0
                       '-'
                     else
                       ''
                     end
      end

      no_cents      = rules.include?(:no_cents) ||
                      (rules.include?(:no_cents_if_whole) && cents % 100 == 0)
      format_string = no_cents ? '$%d' : '$%.2f'
      amount        = format_string % (cents.abs.to_f / 100)
      amount.gsub!('.', options[:separator])
      amount.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
      formatted << amount

      formatted << '</span>' if html_wrap
    end
  end

  private

  def direction_class
    if cents > 0
      'positive'
    elsif cents < 0
      'negative'
    else
      'zero'
    end
  end
end

class Money
  alias_method :lossy_divide, :/
  prepend Extensions
end
