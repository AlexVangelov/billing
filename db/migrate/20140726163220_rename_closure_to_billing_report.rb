class RenameClosureToBillingReport < ActiveRecord::Migration
  def change
    rename_table :billing_closures, :billing_reports
  end
end
