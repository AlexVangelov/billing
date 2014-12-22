class BillingTgFpMapping < ActiveRecord::Migration
  def change
    create_table "billing_tg_fp_mappings", force: true do |t|
      t.integer  "tax_group_id"
      t.integer  "extface_driver_id"
      t.integer  "mapping"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "billing_tg_fp_mappings", ["extface_driver_id"], name: "index_billing_tg_fp_mappings_on_extface_driver_id"
    add_index "billing_tg_fp_mappings", ["tax_group_id"], name: "index_billing_tg_fp_mappings_on_tax_group_id"
  end
end
