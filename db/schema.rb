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

ActiveRecord::Schema.define(version: 20130916012247) do

  create_table "plans", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.integer  "task_count"
    t.string   "review_plan"
    t.integer  "max_task_per_day"
    t.integer  "max_new_task_per_day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trades", force: true do |t|
    t.string   "kp"
    t.string   "op"
    t.integer  "price"
    t.integer  "hand"
    t.datetime "op_time"
    t.integer  "fee"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contract"
    t.integer  "parent_id"
    t.integer  "profit"
  end

end
