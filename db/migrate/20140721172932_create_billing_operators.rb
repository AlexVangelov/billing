class CreateBillingOperators < ActiveRecord::Migration
  def change
    create_table :billing_operators do |t|
      t.integer :master_id
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
