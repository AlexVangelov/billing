class EqalizeSchemasBillingPtFpMapping < ActiveRecord::Migration
  def change
    create_table "billing_pt_fp_mappings", force: true do |t|
      t.integer  "payment_type_id"
      t.integer  "extface_driver_id"
      t.integer  "mapping"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "billing_pt_fp_mappings", ["extface_driver_id"], name: "index_billing_pt_fp_mappings_on_extface_driver_id"
    add_index "billing_pt_fp_mappings", ["payment_type_id"], name: "index_billing_pt_fp_mappings_on_payment_type_id"
  end
end
