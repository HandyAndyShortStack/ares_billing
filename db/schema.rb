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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130920160017) do

  create_table "credit_cards", :force => true do |t|
    t.integer  "user_id"
    t.string   "image_url"
    t.string   "last_4"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "plans", :force => true do |t|
    t.string   "braintree_id"
    t.integer  "billing_frequency"
    t.string   "currency_iso_code"
    t.text     "description"
    t.string   "name"
    t.integer  "number_of_billing_cycles"
    t.decimal  "price"
    t.integer  "trial_duration"
    t.string   "trial_duration_unit"
    t.boolean  "trial_period"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "billing_day_of_month"
    t.date     "billing_period_end_date"
    t.date     "billing_period_start_date"
    t.integer  "failure_count"
    t.date     "first_billing_date"
    t.boolean  "never_expires"
    t.date     "next_billing_date"
    t.integer  "number_of_billing_cycles"
    t.decimal  "next_billing_period_amount"
    t.date     "paid_through_date"
    t.decimal  "balance"
    t.integer  "plan_id"
    t.integer  "user_id"
    t.integer  "credit_card_id"
    t.decimal  "price"
    t.string   "status"
    t.integer  "trial_duration"
    t.string   "trial_duration_unit"
    t.boolean  "trial_period"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "braintree_id"
  end

  create_table "transactions", :force => true do |t|
    t.string   "braintree_id"
    t.string   "avs_error_response_code"
    t.string   "avs_postal_code_response_code"
    t.string   "avs_street_address_response_code"
    t.decimal  "amount"
    t.integer  "credit_card_id"
    t.string   "currency_iso_code"
    t.string   "cvv_response_code"
    t.string   "gateway_rejection_reason"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
