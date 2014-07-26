class EqalizeSchemasBillingDepartment < ActiveRecord::Migration
  def change
    add_index :billing_departments, :deleted_at
  end
end
