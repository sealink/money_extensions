class BigDecimal

  def negative?
    self < BigDecimal('0')
  end

  def positive?
    self > BigDecimal('0')
  end

end
