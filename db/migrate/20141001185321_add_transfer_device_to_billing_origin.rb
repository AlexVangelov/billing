class AddTransferDeviceToBillingOrigin < ActiveRecord::Migration
  def change
    add_reference :billing_origins, :transfer_device, index: true
  end
end
