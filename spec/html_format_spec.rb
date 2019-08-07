require 'money'
require 'money_extensions/string'
require 'money_extensions/html_format'

RSpec.describe Money do
  before { Money.locale_backend = nil }
  after { Money.locale_backend = :legacy }

  let(:money_positive) { Money.new(100)  }
  let(:money_negative) { Money.new(-100) }
  let(:money_zero)     { Money.new(0)    }

  subject { money_positive.format(*rules) }

  it "should format the output correctly" do
    expect(money_negative.format(html_wrap: true, sign_before_symbol: true)).to eq "<span class=\"money negative\">-$1.00</span>"
    expect(money_positive.format(html_wrap: true)).to eq "<span class=\"money positive\">$1.00</span>"
    expect(money_zero.format(html_wrap: true)).to eq "<span class=\"money zero\">$0.00</span>"

    expect(money_positive.format(html_wrap: true)).to eq "<span class=\"money positive\">$1.00</span>"
    expect(money_negative.format(html_wrap: true, sign_before_symbol: true)).to eq "<span class=\"money negative\">-$1.00</span>"
    expect(money_zero.format(html_wrap: true)).to eq "<span class=\"money zero\">$0.00</span>"

    expect(money_positive.format(signed: true, sign_positive: true, sign_before_symbol: true)).to eq "+$1.00"
    expect(money_negative.format(signed: true, sign_before_symbol: true)).to eq "-$1.00"
    expect(money_zero.format(signed: true)).to eq "$0.00"

    expect(money_positive.format(separator: '~')).to eq "$1~00"
  end

  it 'should work with as_html' do
    expect(money_negative.as_html(sign_before_symbol: true)).to eq "<span class=\"money negative\">-$1.00</span>"
    expect(money_positive.as_html).to eq "<span class=\"money positive\">$1.00</span>"
    expect(money_zero.as_html).to eq "<span class=\"money zero\">$0.00</span>"

    expect(money_positive.as_html).to eq "<span class=\"money positive\">$1.00</span>"
    expect(money_negative.as_html(sign_before_symbol: true)).to eq "<span class=\"money negative\">-$1.00</span>"
    expect(money_zero.as_html).to eq "<span class=\"money zero\">$0.00</span>"
  end

  it 'should format cents where appropriate' do
    expect('1.50'.to_money.format(no_cents: true)).to eq '$1'
    expect('1.00'.to_money.format(no_cents: true)).to eq '$1'

    expect('1.50'.to_money.format(no_cents_if_whole: true)).to eq '$1.50'
    expect('1.00'.to_money.format(no_cents_if_whole: true)).to eq '$1'
  end
end
