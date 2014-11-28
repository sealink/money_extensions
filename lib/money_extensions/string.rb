class String
  # Converts this string to a float and then to a Money object in the default currency.
  # It multiplies the converted numeric value by 100 and treats that as cents.
  #
  # NOTE!!!
  # This is overriden as per the default Money .to_money because it assumes
  # a different default currency...
  #
  # '100'.to_money => #<Money @cents=10000>
  # '100.37'.to_money => #<Money @cents=10037>
  def to_money(currency = nil)
    Money.new((self.to_f * 100).round, currency)
  end
end