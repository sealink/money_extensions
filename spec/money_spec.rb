require 'spec_helper'

describe Money do
  it "should get correct direction class" do
    Money.new(-1).direction_class.should == 'negative'
    Money.new(0).direction_class.should == 'zero'
    Money.new(1).direction_class.should == 'positive'
  end

  it "should round correctly" do
    money = Money.new(511)
    money.round.cents.should == 500
    money.round(10).cents.should == 510
    money.round(1).cents.should == 511

    money.round(100, 'up').cents.should == 600
    money.round(100, 'down').cents.should == 500
    money.round(100, 'nearest').cents.should == 500
  end
end

