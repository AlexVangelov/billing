class CreateBillingTaxGroups < ActiveRecord::Migration
  def change
    create_table :billing_tax_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
