class AddTypeToBillingPaymentType < ActiveRecord::Migration
  def change
    add_column :billing_payment_types, :type, :string
  end
end
