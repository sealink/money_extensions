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

  it "should convert to from money and underlying cents object" do
    @model = Model.create!(:price => 5.to_money, :cost_in_cents => 300)
    @model.price_in_cents.should == 500
    @model.cost.cents.should == 300
  end
end

