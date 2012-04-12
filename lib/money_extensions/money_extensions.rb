require 'money'

class Money
  
  # Override division -- should not do it, but use split_between
  alias_method :lossy_divide, :/
  def /(*params)
    raise "Division of money NOT allowed - use 'split_between' to avoid rounding errors"
  end

  def to_d
    BigDecimal.new("#{cents/100.0}")
  end

  # Split the money between the specified number - and return an array of money
  # Remainder in splits are given to the highest value e.g.
  # $2.00 splits [40, 81, 40] into [49, 102, 49]
  # $1.01 splits [ 1,  1,  1] into [35,  33, 33]
  def split_between(params)
    #if just a number is passed in, then money is split equally
    if params.is_a?(Fixnum)
      divisor = params
      raise ArgumentError, "Can only split up over a positive number" if divisor < 1
      
      rounded_split = self.lossy_divide(divisor)
      results = Array.new(divisor, rounded_split) # Create with 'divisor' num elements
      
      #if an array of monies is passed in, then split in proportions
    elsif params.is_a?(Array)

      raise ArgumentError, "Can only split up over at least one ration" if params.empty? && !self.zero?

      
      results = params.map{|p| p.is_a?(Money) ? p.cents : p}

      total = results.inject(:+)
      if total.zero?
        return Array.new(results.size, Money.new(0)) if self.zero?
        raise ArgumentError, "Total of ratios should not be zero! You sent in: #{params.inspect}" 
      end

      if self.positive?
        results.map!{|ratio| Money.new( ( (self.cents * (ratio.to_f / total)).floor))}
      else
        results.map!{|ratio| Money.new( ( (self.cents * (ratio.to_f / total)).ceil))}
      end
    else
      raise "Either a fixnum or array has to be passed in for splitting money"
    end
    
    #find the rounding error and apply it to the biggest value share.
    biggest_value_index = results.index(positive? ? results.max : results.min)
    results[biggest_value_index] += self - results.total_money
    
    return results
  end

  
  DEFAULT_FORMAT_RULES = [:html]
  # HACK COZ WE ARE PRETENDING WE DON'T HAVE CURRENCY!!!
  #
  # TODO: Make this not a hack...
  def to_s
    sprintf("%.2f", cents.to_f / 100) #currency.subunit_to_unit)
  end

  def inspect
    inbuilt_inspect_style_id = '%x' % (object_id << 1)
    "\#<Money:0x#{inbuilt_inspect_style_id} $#{self}>"
  end

  # Money's default formatted is not flexible enought.
  #  - we don't want it to say 'free' when 0 (not correct for 'discounts' and such)
  def format(*rules)
    rules = rules.empty? ? DEFAULT_FORMAT_RULES.dup : rules.flatten

    options = {}
    rules.each do |rule|
      if rule.is_a? Hash
        options = rule
      end
    end
    
    html_wrap = rules.include?(:html)

    options[:delimiter] ||= ','
    options[:separator] ||= '.'

    ''.tap do |formatted|
      formatted << "<span class=\"money #{direction_class}\">" if html_wrap
      
      rules << :signed if cents < 0
      
      if rules.include?(:signed)
        formatted <<  if cents > 0
          '+'
        elsif cents < 0
          '-'
        else
          ''
        end
      end
      
      format_string = rules.include?(:no_cents) ? "$%d" : "$%.2f"
      amount = format_string % (cents.abs.to_f / 100)
      amount.gsub!('.', options[:separator])
      amount.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
      formatted << amount
      
      formatted << "</span>" if html_wrap
    end
  end

  def direction_class
    if cents > 0
      'positive'
    elsif cents < 0
      'negative'
    else
      'zero'
    end
  end

  def mark_up(mark_up_definition)
    mark_up_cents = mark_up_definition.cents || 0
    rounding_direction = mark_up_definition.rounding_direction.try(:to_sym)
    multiplier = ((100 + mark_up_definition.percent)/100.0)
    (self * multiplier).round(mark_up_definition.rounding_cents, rounding_direction) + Money.new(mark_up_cents)
  end

  # money = Money.new(501)
  # money.round
  # => 500
  # money.round(10)
  # => 510
  # money.round(1)
  # => 511

  # money.round(100, 'up')
  # => 600
  # money.round(100, 'down')
  # => 500
  # money.round(100, 'nearest')
  # => 500
  def round(round_to_cents = 100, direction = :nearest)
    round_to_cents = 100 if round_to_cents.nil?
    case direction.to_sym
    when :nearest
      cents = (@cents + round_to_cents/2) / round_to_cents * round_to_cents
    when :up
      cents = (@cents + round_to_cents) / round_to_cents * round_to_cents
    when :down
      cents = (@cents) / round_to_cents * round_to_cents
    else
    end
    Money.new(cents)
  end

  
  def abs
    if cents >= 0
      self.clone
    else
      Money.new(0 - cents)
    end
  end

  def positive?
    cents > 0
  end

  def negative?
    cents < 0
  end
end
