class ChangeTableBaseBillingPlus < ActiveRecord::Migration
  def change
    change_table :billing_plus do |t|
      t.integer   :master_id
      t.belongs_to :tax_group, index: true
      t.belongs_to :department, index: true
      t.integer   :number
      t.money     :price
      t.string    :code
      t.string    :type
      t.boolean   :banned
      t.timestamp :deleted_at
    end
  end
end
