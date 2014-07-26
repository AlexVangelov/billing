class AddStatusToBillingPayment < ActiveRecord::Migration
  def change
    add_column :billing_payments, :status, :string
  end
end
