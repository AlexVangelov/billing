class ChangeTableBaseBillingTaxGroup < ActiveRecord::Migration
  def change
    change_table :billing_tax_groups do |t|
      t.integer   :master_id
      t.integer   :number
      t.decimal   :percent_ratio, precision: 6, scale: 3 
      t.boolean   :banned
      t.string    :type
      t.timestamp :deleted_at
    end
  end
end
