class CreateBillingCharges < ActiveRecord::Migration
  def change
    create_table :billing_charges do |t|
      t.belongs_to :account, index: true
      t.references :chargable, polymorphic: true, index: true
      t.money :price
      
      t.timestamps
    end
  end
end
