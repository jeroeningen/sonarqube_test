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

ActiveRecord::Schema.define(version: 20151227152602) do

  create_table "bankaccounts", force: :cascade do |t|
    t.integer  "user_id",                             default: 0,   null: false
    t.decimal  "balance",    precision: 10, scale: 2, default: 0.0, null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "bankaccounts", ["user_id"], name: "index_bankaccounts_on_user_id"

  create_table "transactions", force: :cascade do |t|
    t.integer  "bankaccount_id",                                  default: 0,   null: false
    t.integer  "foreign_bankaccount_id",                          default: 0,   null: false
    t.decimal  "amount",                 precision: 10, scale: 2, default: 0.0, null: false
    t.text     "comment"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "transactions", ["bankaccount_id"], name: "index_transactions_on_bankaccount_id"
  add_index "transactions", ["foreign_bankaccount_id"], name: "index_transactions_on_foreign_bankaccount_id"

  create_table "users", force: :cascade do |t|
    t.string   "firstname",       default: "", null: false
    t.string   "lastname",        default: "", null: false
    t.string   "email",           default: "", null: false
    t.string   "password_digest", default: "", null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

end
