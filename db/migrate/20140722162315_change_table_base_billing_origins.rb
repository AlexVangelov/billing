class ChangeTableBaseBillingOrigins < ActiveRecord::Migration
  def change
    change_table :billing_origins do |t|
      t.integer   :master_id
      t.integer   :fiscal_device_id
      t.boolean   :banned
      t.timestamp :deleted_at
      t.string    :type
      t.string    :payment_model, default: 'Billing::PaymentWithType'
    end
    add_index :billing_origins, :fiscal_device_id
  end
end
