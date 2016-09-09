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

ActiveRecord::Schema.define(version: 20160827125309) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.string   "teacher_email"
    t.string   "student_email"
    t.string   "teacher_name"
    t.string   "student_name"
    t.text     "random"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "experiences", force: :cascade do |t|
    t.string   "description"
    t.string   "text"
    t.integer  "teacher_id"
    t.datetime "start"
    t.datetime "end_time"
    t.binary   "present"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "teacher_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "name"
    t.text     "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "message"
    t.string   "sender_email"
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
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
    t.string   "nickname"
    t.text     "image"
    t.string   "name"
    t.integer  "view_count",             default: 0
  end

  add_index "teachers", ["email"], name: "index_teachers_on_email"
  add_index "teachers", ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
  add_index "teachers", ["uid", "provider"], name: "index_teachers_on_uid_and_provider", unique: true

end
