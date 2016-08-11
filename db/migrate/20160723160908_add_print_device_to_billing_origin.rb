class AddPrintDeviceToBillingOrigin < ActiveRecord::Migration
  def change
    add_column :billing_origins, :print_device_id, :integer
  end
end
