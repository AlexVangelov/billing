class EqalizeSchemasBillingOrigin < ActiveRecord::Migration
  def change
    add_index :billing_origins, :deleted_at
  end
end
