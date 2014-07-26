class EqalizeSchemasBillingClosure < ActiveRecord::Migration
  def change
    create_table "billing_closures", force: true do |t|
      t.integer  "master_id"
      t.integer  "origin_id"
      t.integer  "payments_sum_cents",       default: 0,     null: false
      t.string   "payments_sum_currency",    default: "USD", null: false
      t.integer  "payments_cash_cents",      default: 0,     null: false
      t.string   "payments_cash_currency",   default: "USD", null: false
      t.integer  "payments_fiscal_cents",    default: 0,     null: false
      t.string   "payments_fiscal_currency", default: "USD", null: false
      t.text     "note"
      t.string   "type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "extface_job_id"
      t.date     "f_period_from"
      t.date     "f_period_to"
      t.boolean  "zeroing"
      t.string   "f_operation"
    end
  
    add_index "billing_closures", ["origin_id"], name: "index_billing_closures_on_origin_id"
  end
end
