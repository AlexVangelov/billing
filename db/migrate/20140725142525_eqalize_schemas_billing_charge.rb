class EqalizeSchemasBillingCharge < ActiveRecord::Migration
  def change
    change_table :billing_charges do |t|
      t.string      :name
      t.string      :description
      t.belongs_to  :origin
      t.money       :value
      t.timestamp   :deleted_at
      t.timestamp   :revenue_at
    end
    
    add_index :billing_charges, :origin_id
    add_index :billing_charges, :deleted_at
    add_index :billing_charges, :revenue_at
  end
end
