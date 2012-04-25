ActiveRecord::Schema.define(:version => 1) do
  create_table :models do |t|
    t.integer :price_in_cents, :cost_in_cents
  end
end
