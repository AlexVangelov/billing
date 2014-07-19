class CreateBillingPlus < ActiveRecord::Migration
  def change
    create_table :billing_plus do |t|
      t.string :name

      t.timestamps
    end
  end
end
