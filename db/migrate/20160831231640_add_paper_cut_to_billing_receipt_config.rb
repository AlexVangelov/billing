class AddPaperCutToBillingReceiptConfig < ActiveRecord::Migration
  def change
    add_column :billing_receipt_configs, :paper_cut, :boolean
  end
end
