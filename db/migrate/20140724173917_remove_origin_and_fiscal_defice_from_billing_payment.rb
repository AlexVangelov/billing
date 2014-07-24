class RemoveOriginAndFiscalDeficeFromBillingPayment < ActiveRecord::Migration
  def change
    remove_column :billing_payments, :origin_id, :integer
    remove_column :billing_payments, :fiscal_device_id, :integer
  end
end
