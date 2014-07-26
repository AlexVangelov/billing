class EqalizeSchemasBillingVersion < ActiveRecord::Migration
  def change
    create_table "billing_versions", force: true do |t|
      t.string   "item_type",  null: false
      t.integer  "item_id",    null: false
      t.string   "event",      null: false
      t.string   "whodunnit"
      t.text     "object"
      t.datetime "created_at"
      t.string   "ip"
      t.string   "user_agent"
    end
  
    add_index "billing_versions", ["item_type", "item_id"], name: "index_billing_versions_on_item_type_and_item_id"
  end
end
