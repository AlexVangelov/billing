class RenameBillingDiscountsToModifiers < ActiveRecord::Migration
  def change
    rename_table :billing_discounts, :billing_modifiers
  end
end
