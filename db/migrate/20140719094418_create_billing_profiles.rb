class CreateBillingProfiles < ActiveRecord::Migration
  def change
    create_table :billing_profiles do |t|
      t.string :name

      t.timestamps
    end
  end
end
