class AddCustomCommandsToBillingReceiptConfig < ActiveRecord::Migration
  def change
    add_column :billing_receipt_configs, :custom_commands, :boolean
    add_column :billing_receipt_configs, :custom_commands_text, :string
  end
end
