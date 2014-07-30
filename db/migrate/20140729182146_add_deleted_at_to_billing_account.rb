class AddDeletedAtToBillingAccount < ActiveRecord::Migration
  def change
    add_column :billing_accounts, :deleted_at, :timestamp, index: true
  end
end
