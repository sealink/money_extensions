require 'spec_helper'

describe BigDecimal do

  it "should allow verifying if it's a positive value" do
    BigDecimal.new('-1').should_not be_positive
    BigDecimal.new('0').should_not be_positive
    BigDecimal.new('1').should be_positive
  end
  
  it "should allow verifying if it's a negative value" do
    BigDecimal.new('-1').should be_negative
    BigDecimal.new('0').should_not be_negative
    BigDecimal.new('1').should_not be_negative
  end
  
end
