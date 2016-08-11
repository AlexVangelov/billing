class AddPrintJobToBillingBill < ActiveRecord::Migration
  def change
    add_column :billing_bills, :print_job_id, :integer
  end
end
