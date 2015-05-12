class AddDeletedAtToBillingReport < ActiveRecord::Migration
  def change
    add_column :billing_reports, :deleted_at, :timestamp
  end
end
