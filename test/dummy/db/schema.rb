# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140721173106) do

  create_table "billing_accounts", force: true do |t|
    t.integer  "billable_id"
    t.string   "billable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "charges_sum_cents",       default: 0,     null: false
    t.string   "charges_sum_currency",    default: "USD", null: false
    t.integer  "discounts_sum_cents",     default: 0,     null: false
    t.string   "discounts_sum_currency",  default: "USD", null: false
    t.integer  "payments_sum_cents",      default: 0,     null: false
    t.string   "payments_sum_currency",   default: "USD", null: false
    t.integer  "total_cents",             default: 0,     null: false
    t.string   "total_currency",          default: "USD", null: false
    t.integer  "balance_cents",           default: 0,     null: false
    t.string   "balance_currency",        default: "USD", null: false
    t.integer  "surcharges_sum_cents",    default: 0,     null: false
    t.string   "surcharges_sum_currency", default: "USD", null: false
  end

  add_index "billing_accounts", ["billable_id", "billable_type"], name: "index_billing_accounts_on_billable_id_and_billable_type"

  create_table "billing_charges", force: true do |t|
    t.integer  "account_id"
    t.integer  "chargable_id"
    t.string   "chargable_type"
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "billing_charges", ["account_id"], name: "index_billing_charges_on_account_id"
  add_index "billing_charges", ["chargable_id", "chargable_type"], name: "index_billing_charges_on_chargable_id_and_chargable_type"

  create_table "billing_departments", force: true do |t|
    t.integer  "master_id"
    t.string   "name"
    t.integer  "tax_group_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billing_modifiers", force: true do |t|
    t.integer  "account_id"
    t.integer  "charge_id"
    t.decimal  "percent_ratio",        precision: 6, scale: 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fixed_value_cents",                            default: 0,     null: false
    t.string   "fixed_value_currency",                         default: "USD", null: false
  end

  add_index "billing_modifiers", ["account_id"], name: "index_billing_modifiers_on_account_id"

  create_table "billing_operators", force: true do |t|
    t.integer  "master_id"
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billing_origins", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billing_payment_types", force: true do |t|
    t.string   "name"
    t.boolean  "cash"
    t.boolean  "fiscal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "billing_payments", force: true do |t|
    t.integer  "account_id"
    t.integer  "value_cents",     default: 0,     null: false
    t.string   "value_currency",  default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "payment_type_id"
  end

  add_index "billing_payments", ["account_id"], name: "index_billing_payments_on_account_id"

  create_table "billing_plus", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billing_profiles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billing_tax_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
