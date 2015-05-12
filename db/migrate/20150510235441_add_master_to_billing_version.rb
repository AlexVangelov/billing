class AddMasterToBillingVersion < ActiveRecord::Migration
  def change
    add_column :billing_versions, :master_id, :integer
    add_column :billing_versions, :master_type, :string
  end
end
