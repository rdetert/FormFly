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

ActiveRecord::Schema.define(:version => 20110128073108) do

  create_table "assetable", :force => true do |t|
  end

  create_table "image_uploads", :force => true do |t|
    t.integer  "session_workaround_id"
    t.integer  "assetable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.integer  "assetable_id"
    t.string   "slot"
    t.string   "data_uid"
    t.boolean  "delete_from_disk", :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "assetable_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "session_workarounds", :force => true do |t|
    t.string   "session_id"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "session_workarounds", ["session_id", "action"], :name => "index_session_workarounds_on_session_id_and_action"

end
