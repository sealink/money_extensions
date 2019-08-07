# frozen_string_literal: true

class Numeric
  # Converts this numeric to a Money object in the default currency. It
  # multiplies the numeric value by 100 and treats that as cents.
  #
  # NOTE!!!
  # This is overriden as per the default Money .to_money because it assumes
  # a different default currency...
  #
  # 100.to_money => #<Money @cents=10000>
  # 100.37.to_money => #<Money @cents=10037>
  # require 'bigdecimal'
  # BigDecimal.new('100').to_money => #<Money @cents=10000>
  def to_money(currency = nil)
    ::Money.new((self * 100).round, currency || Money.default_currency)
  end
end
