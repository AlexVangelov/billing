class EqalizeSchemasBillingOperators < ActiveRecord::Migration
  def change
    add_index :billing_operators, :deleted_at
  end
end
