class CreateBillingDepartments < ActiveRecord::Migration
  def change
    create_table :billing_departments do |t|
      t.integer :master_id
      t.string :name
      t.integer :tax_group_id
      t.string :type

      t.timestamps
    end
  end
end
