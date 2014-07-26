class AddReportToBillingAccount < ActiveRecord::Migration
  def change
    add_reference :billing_accounts, :report, index: true
  end
end
