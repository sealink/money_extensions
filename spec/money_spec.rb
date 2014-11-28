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

  it "should deny division of money (to prevent rounding errors)" do
    lambda { Money.new(50)/10 }.should raise_error(RuntimeError)
  end

  it "should split money correctly" do
    money = Money.new(100)
    
    lambda { money.split_between(0) }.should raise_error(ArgumentError)
    lambda { money.split_between(-100) }.should raise_error(ArgumentError)
    lambda { money.split_between(0.1) }.should raise_error(RuntimeError)

    money.split_between(3).should == [34,33,33].map{ |i| Money.new(i)}

    lambda { money.split_between([]) }.should raise_error(ArgumentError)
    lambda { money.split_between([-1,1]) }.should raise_error(ArgumentError)
    
    money.split_between([1,2,2,5]).should == [10,20,20,50].map{ |i| Money.new(i)}
    money.split_between([1,2]).should == [33,67].map{ |i| Money.new(i)} 

    

    money_negative = Money.new(-100)
    money_negative.split_between(3).should == [-32,-34,-34].map{ |i| Money.new(i)}
    money_negative.split_between([1,2,2,5]).should == [-10,-20,-20,-50].map{ |i| Money.new(i)}
    money_negative.split_between([1,2]).should == [-33,-67].map{ |i| Money.new(i)} 

    money_zero = Money.new(0)
    money_zero.split_between([1,2]).should == Array.new(2,money_zero)

  end

  it "should round split amounts" do
    Money.new(200).split_between([81, 40, 40]).should == [100, 50, 50].map{ |i| Money.new(i) }
  end

  it "should assign rounding to max absolute" do
    # the -8 is the largest ABSOLUTE number... 
    #   -8 / 3 == -2.66666 = 2.67
    #   it receives the rounding of +1c
    Money.new(100).split_between([1,    -8,   7,   3]).should ==
                                 [33, -266, 233, 100].map{ |i| Money.new(i) }
  end

  it "should return a nice, Big Decimal if so converted" do
    money = Money.new(1428)
    bigdecimal = BigDecimal.new("14.28")
    money.to_d.should == bigdecimal
  end

  it "should be createable from strings and numbers" do
    money = Money.new(100)
    "1".to_money.cents.should == money.cents
    BigDecimal.new('1').to_money.cents.should == money.cents
    100.total_money.cents.should == money.cents
  end

  it "should know positives, negatives, and absolutes" do
    money_positive = Money.new(100)
    money_negative = Money.new(-100)
    money_zero = Money.new(0)

    money_positive.positive?.should == true
    money_positive.negative?.should == false

    money_negative.positive?.should == false
    money_negative.negative?.should == true

    money_zero.positive?.should == false
    money_zero.negative?.should == false

    money_positive.abs.should == money_positive
    money_negative.abs.should == money_positive
    money_zero.abs.should == money_zero
  end

  it "should format the output correctly" do
    money_positive = Money.new(100)
    money_negative = Money.new(-100)
    money_zero = Money.new(0)

    money_positive.format.should == "<span class=\"money positive\">$1.00</span>"
    money_negative.format.should == "<span class=\"money negative\">-$1.00</span>"
    money_zero.format.should == "<span class=\"money zero\">$0.00</span>"

    money_positive.format(:html).should == "<span class=\"money positive\">$1.00</span>"
    money_negative.format(:html).should == "<span class=\"money negative\">-$1.00</span>"
    money_zero.format(:html).should == "<span class=\"money zero\">$0.00</span>"

    money_positive.format(:signed).should == "+$1.00"
    money_negative.format(:signed).should == "-$1.00"
    money_zero.format(:signed).should == "$0.00"

    "1.50".to_money.format(:separator => '~').should == "$1~50"
  end

  it 'should format cents where appropriate' do
    '1.50'.to_money.format(:no_cents).should == '$1'
    '1.00'.to_money.format(:no_cents).should == '$1'

    '1.50'.to_money.format(:hide_zero_cents).should == '$1.50'
    '1.00'.to_money.format(:hide_zero_cents).should == '$1'
  end

end

