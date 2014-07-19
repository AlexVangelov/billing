class AddFixedValueToBillingDiscount < ActiveRecord::Migration
  def change
    change_table :billing_discounts do |t|
      t.money :fixed_value
    end
  end
end
