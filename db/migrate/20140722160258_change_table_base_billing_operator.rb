class ChangeTableBaseBillingOperator < ActiveRecord::Migration
  def change
    change_table :billing_operators do |t|
      t.integer   :number
      t.boolean   :banned
      t.timestamp :deleted_at
    end
  end
end
