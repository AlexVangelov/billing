class AddReceiptConfigToBillingOrigin < ActiveRecord::Migration
  def change
    add_reference :billing_origins, :receipt_config, index: true, foreign_key: true
  end
end
