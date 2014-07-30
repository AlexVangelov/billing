class AddNumberToBillingAccount < ActiveRecord::Migration
  def change
    add_column :billing_accounts, :number, :string
  end
end
