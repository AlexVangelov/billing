class ChangeTableBaseBillingPaymentType < ActiveRecord::Migration
  def change
    change_table :billing_payment_types do |t|
      t.integer   :master_id
      t.integer   :number
      t.boolean   :banned
      t.timestamp :deleted_at
    end
  end
end
