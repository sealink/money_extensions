require 'spec_helper'

DB_FILE = 'tmp/test_db'
FileUtils.mkdir_p File.dirname(DB_FILE)
FileUtils.rm_f DB_FILE

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => DB_FILE

load('spec/schema.rb')

load('rails/init.rb')

describe "ActiveRecord::Base" do
  class Model < ActiveRecord::Base
    money_fields :price, :cost
  end

  let(:model) { Model.create!(:price => 5.to_money, :cost_in_cents => 300) }

  it "should convert to from money and underlying cents object" do
    expect(model.price_in_cents).to eq 500
    expect(model.cost.cents).to eq 300
  end
end

