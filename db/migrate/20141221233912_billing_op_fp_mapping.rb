class BillingOpFpMapping < ActiveRecord::Migration
  def change
    create_table "billing_op_fp_mappings", force: true do |t|
      t.integer  "operator_id"
      t.integer  "extface_driver_id"
      t.integer  "mapping"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "billing_op_fp_mappings", ["extface_driver_id"], name: "index_billing_op_fp_mappings_on_extface_driver_id"
    add_index "billing_op_fp_mappings", ["operator_id"], name: "index_billing_op_fp_mappings_on_operator_id"
  end
end
