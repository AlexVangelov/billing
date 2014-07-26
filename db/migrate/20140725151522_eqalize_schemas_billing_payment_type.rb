class EqalizeSchemasBillingPaymentType < ActiveRecord::Migration
  def change
    change_table :billing_payment_types do |t|
      t.boolean   :print_copy
    end
    add_index :billing_payment_types, :deleted_at
  end
end
