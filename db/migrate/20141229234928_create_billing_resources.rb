class CreateBillingResources < ActiveRecord::Migration
  def change
    create_table :billing_resources do |t|
      t.integer :master_id
      t.string :name
      t.text :properties
      t.boolean  :banned
      t.string :type

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
