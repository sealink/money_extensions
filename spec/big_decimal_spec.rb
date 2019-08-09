require 'spec_helper'

describe BigDecimal do

  it "should allow verifying if it's a positive value" do
    expect(BigDecimal('-1')).to_not be_positive
    expect(BigDecimal('0')).to_not be_positive
    expect(BigDecimal('1')).to be_positive
  end

  it "should allow verifying if it's a negative value" do
    expect(BigDecimal('-1')).to be_negative
    expect(BigDecimal('0')).to_not be_negative
    expect(BigDecimal('1')).to_not be_negative
  end

end
