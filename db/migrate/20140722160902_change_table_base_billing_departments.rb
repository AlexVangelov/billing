class ChangeTableBaseBillingDepartments < ActiveRecord::Migration
  def change
    change_table :billing_departments do |t|
      t.integer   :number
      t.boolean   :banned
      t.timestamp :deleted_at
    end
    add_index :billing_departments, :tax_group_id
  end
end
