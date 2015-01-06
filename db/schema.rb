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

ActiveRecord::Schema.define(version: 20140127133413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorite_assignments", force: true do |t|
    t.integer  "liker_id"
    t.integer  "favorite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_assignments", ["favorite_id"], name: "index_favorite_assignments_on_favorite_id", using: :btree
  add_index "favorite_assignments", ["liker_id"], name: "index_favorite_assignments_on_liker_id", using: :btree

  create_table "offer_assignments", force: true do |t|
    t.integer  "shop_id"
    t.integer  "offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "offer_assignments", ["offer_id"], name: "index_offer_assignments_on_offer_id", using: :btree
  add_index "offer_assignments", ["shop_id"], name: "index_offer_assignments_on_shop_id", using: :btree

  create_table "offers", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.date     "expiry",             default: '2014-02-02'
    t.string   "category"
    t.boolean  "pending",            default: false
    t.boolean  "confirmed",          default: false
    t.string   "pending_comment"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "offers", ["owner_id"], name: "index_offers_on_owner_id", using: :btree

  create_table "shops", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "address"
    t.string   "email"
    t.string   "phone"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.boolean  "pending",            default: false
    t.boolean  "confirmed",          default: false
    t.string   "pending_comment"
    t.integer  "manager_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["manager_id"], name: "index_shops_on_manager_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_url"
    t.string   "phone"
    t.string   "firstname"
    t.string   "lastname"
    t.date     "birthday"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "rank"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
