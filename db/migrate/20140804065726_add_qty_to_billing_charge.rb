class AddQtyToBillingCharge < ActiveRecord::Migration
  def change
    add_column :billing_charges, :qty, :decimal, precision: 6, scale: 3
  end
end
