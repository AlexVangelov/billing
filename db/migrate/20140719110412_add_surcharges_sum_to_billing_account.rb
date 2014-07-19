class AddSurchargesSumToBillingAccount < ActiveRecord::Migration
  def change
    change_table :billing_accounts do |t|
      t.money :surcharges_sum
    end
  end
end
