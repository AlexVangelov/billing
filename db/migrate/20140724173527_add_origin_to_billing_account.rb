class AddOriginToBillingAccount < ActiveRecord::Migration
  def change
    change_table :billing_accounts do |t|
      t.belongs_to :origin, index: true
    end
  end
end
