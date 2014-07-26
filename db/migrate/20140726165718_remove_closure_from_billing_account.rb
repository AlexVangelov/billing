class RemoveClosureFromBillingAccount < ActiveRecord::Migration
  def change
    remove_index :billing_payments, :closure_id
    remove_column :billing_payments, :closure_id, :integer
  end
end
