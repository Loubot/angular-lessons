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

ActiveRecord::Schema.define(version: 20170126142705) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id1"
    t.integer  "user_id2"
    t.string   "user_email1"
    t.string   "user_email2"
    t.string   "user_name1"
    t.string   "user_name2"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "experiences", force: :cascade do |t|
    t.string   "description"
    t.integer  "teacher_id"
    t.datetime "start"
    t.datetime "end_time"
    t.binary   "present"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "teacher_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["teacher_id"], name: "index_identities_on_teacher_id"

  create_table "locations", force: :cascade do |t|
    t.integer  "teacher_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "name"
    t.text     "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "county"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "text"
    t.integer  "sender_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string   "name"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "avatar"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "qualifications", force: :cascade do |t|
    t.string   "title"
    t.string   "school"
    t.datetime "start"
    t.datetime "end_time"
    t.integer  "teacher_id"
    t.binary   "present"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "subjects_teachers", id: false, force: :cascade do |t|
    t.integer "subject_id", null: false
    t.integer "teacher_id", null: false
  end

  add_index "subjects_teachers", ["subject_id", "teacher_id"], name: "index_subjects_teachers_on_subject_id_and_teacher_id"

  create_table "teachers", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "profile"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "overview"
    t.boolean  "is_teacher",             default: false
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.integer  "view_count",             default: 0
    t.boolean  "primary"
    t.boolean  "jc"
    t.boolean  "lc"
    t.boolean  "third_level"
  end

  add_index "teachers", ["email"], name: "index_teachers_on_email"
  add_index "teachers", ["jc"], name: "index_teachers_on_jc"
  add_index "teachers", ["lc"], name: "index_teachers_on_lc"
  add_index "teachers", ["primary"], name: "index_teachers_on_primary"
  add_index "teachers", ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
  add_index "teachers", ["third_level"], name: "index_teachers_on_third_level"
  add_index "teachers", ["uid", "provider"], name: "index_teachers_on_uid_and_provider", unique: true

end
