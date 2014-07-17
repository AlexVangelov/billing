class CreateBillingPayments < ActiveRecord::Migration
  def change
    create_table :billing_payments do |t|
      t.belongs_to :account, index: true
      t.money :value

      t.timestamps
    end
  end
end
