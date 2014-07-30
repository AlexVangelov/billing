class AddNameToBillingAccount < ActiveRecord::Migration
  def change
    add_column :billing_accounts, :name, :string
  end
end
