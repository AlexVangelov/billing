class CreateBillingReceiptConfigs < ActiveRecord::Migration
  def change
    create_table :billing_receipt_configs do |t|
      t.integer :master_id
      t.string :type
      t.string :name
      t.string :discount_text
      t.string :surcharge_text
      t.boolean :sound_signal
      t.boolean :open_cash_drawer

      t.timestamps null: false
    end
  end
end
