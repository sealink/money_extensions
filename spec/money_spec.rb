require 'spec_helper'

describe Money do
  it "should deny division of money (to prevent rounding errors)" do
    expect { Money.new(50)/10 }.to raise_error(RuntimeError)
  end

  it 'should split evenly between' do
    money = Money.new(100)

    expect(money.split_evenly_between(3)).to eq [34,33,33].map{ |i| Money.new(i) }
    expect(money.split_evenly_between(3).sum(Money.zero)).to eq money

    expect(money.split_evenly_between(6)).to eq [17,17,17,17,16,16].map{ |i| Money.new(i) }
    expect(money.split_evenly_between(6).sum(Money.zero)).to eq money
  end

  it 'should split evenly between negative numbers' do
    money = Money.new(-100)

    expect(money.split_evenly_between(3)).to eq [-33,-33,-34].map{ |i| Money.new(i) }
    expect(money.split_evenly_between(3).sum(Money.zero)).to eq money

    expect(money.split_evenly_between(6)).to eq [-16,-16,-17,-17,-17,-17].map{ |i| Money.new(i) }
    expect(money.split_evenly_between(6).sum(Money.zero)).to eq money
  end

  it "should split money correctly" do
    money = Money.new(100)

    expect { money.split_between(0) }.to raise_error(ArgumentError)
    expect { money.split_between(-100) }.to raise_error(ArgumentError)
    expect { money.split_between(0.1) }.to raise_error(RuntimeError)

    expect(money.split_between(3)).to eq [34,33,33].map{ |i| Money.new(i)}

    expect { money.split_between([]) }.to raise_error(ArgumentError)
    expect { money.split_between([-1,1]) }.to raise_error(ArgumentError)

    expect(money.split_between([1,2,2,5])).to eq [10,20,20,50].map{ |i| Money.new(i)}
    expect(money.split_between([1,2])).to eq [33,67].map{ |i| Money.new(i)}

    money_negative = Money.new(-100)
    expect(money_negative.split_between(3)).to eq [-33,-33,-34].map{ |i| Money.new(i)}
    expect(money_negative.split_between([1,2,2,5])).to eq [-10,-20,-20,-50].map{ |i| Money.new(i)}
    expect(money_negative.split_between([1,2])).to eq [-33,-67].map{ |i| Money.new(i)}

    money_zero = Money.new(0)
    expect(money_zero.split_between([1,2])).to eq Array.new(2,money_zero)
  end

  it "should round split amounts" do
    expect(Money.new(200).split_between([81, 40, 40])).to eq [100, 50, 50].map{ |i| Money.new(i) }
  end

  it "should assign rounding to max absolute" do
    # the -8 is the largest ABSOLUTE number...
    #   -8 / 3 == -2.66666 = 2.67
    #   it receives the rounding of +1c
    expected_money = [33, -266, 233, 100].map{ |i| Money.new(i) }
    expect(Money.new(100).split_between([1, -8, 7, 3])).to eq expected_money
  end

  it "should return a nice, Big Decimal if so converted" do
    money = Money.new(1428)
    bigdecimal = BigDecimal("14.28")
    expect(money.to_d).to eq bigdecimal
  end

  it "should be createable from strings and numbers" do
    money = Money.new(100)
    expect("1".to_money.cents).to eq money.cents
    expect(BigDecimal('1').to_money.cents).to eq money.cents
    expect(100.total_money.cents).to eq money.cents
  end

  let(:money_positive) { Money.new(100)  }
  let(:money_negative) { Money.new(-100) }
  let(:money_zero)     { Money.new(0)    }

  it "should know positives, negatives, and absolutes" do
    expect(money_positive.positive?).to eq true
    expect(money_positive.negative?).to eq false

    expect(money_negative.positive?).to eq false
    expect(money_negative.negative?).to eq true

    expect(money_zero.positive?).to eq false
    expect(money_zero.negative?).to eq false

    expect(money_positive.abs).to eq money_positive
    expect(money_negative.abs).to eq money_positive
    expect(money_zero.abs).to eq money_zero
  end
end
