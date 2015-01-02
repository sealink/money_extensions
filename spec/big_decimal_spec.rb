require 'spec_helper'

describe BigDecimal do

  it "should allow verifying if it's a positive value" do
    expect(BigDecimal.new('-1')).to_not be_positive
    expect(BigDecimal.new('0')).to_not be_positive
    expect(BigDecimal.new('1')).to be_positive
  end

  it "should allow verifying if it's a negative value" do
    expect(BigDecimal.new('-1')).to be_negative
    expect(BigDecimal.new('0')).to_not be_negative
    expect(BigDecimal.new('1')).to_not be_negative
  end

end
