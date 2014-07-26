class EqalizeSchemasBillingPayment < ActiveRecord::Migration
  def change
    change_table :billing_payments do |t|
      t.string    :name
      t.string    :description
      t.string    :external_token
      t.string    :note
      t.integer   :closure_id
      t.timestamp :deleted_at
    end
    add_index :billing_payments, :deleted_at
    add_index :billing_payments, :closure_id
  end
end
