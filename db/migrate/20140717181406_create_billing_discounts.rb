class CreateBillingDiscounts < ActiveRecord::Migration
  def change
    create_table :billing_discounts do |t|
      t.belongs_to :account, index: true
      t.belongs_to :charge
      t.decimal :percent_ratio, precision: 6, scale: 3 

      t.timestamps
    end
  end
end
