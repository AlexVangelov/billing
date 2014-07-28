class AddAutofinAndFinalizedAtToBillingAccount < ActiveRecord::Migration
  def change
    add_column :billing_accounts, :autofin, :boolean, default: true
    add_column :billing_accounts, :finalized_at, :timestamp
  end
end
