class CreateBillingPaymentTypes < ActiveRecord::Migration
  def change
    create_table :billing_payment_types do |t|
      t.string :name
      t.boolean :cash
      t.boolean :fiscal

      t.timestamps
    end
  end
end
