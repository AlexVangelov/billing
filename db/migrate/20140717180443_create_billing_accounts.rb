class CreateBillingAccounts < ActiveRecord::Migration
  def change
    create_table :billing_accounts do |t|
      t.references :billable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
