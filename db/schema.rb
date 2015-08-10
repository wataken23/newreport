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

ActiveRecord::Schema.define(version: 20150805120706) do

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "repbody_id"
    t.date     "date"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hyperlinks", force: :cascade do |t|
    t.integer  "repbody_id"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "myfiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "filename"
    t.string   "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repbodies", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.date     "date"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "commentexis"
    t.integer  "lock_version", default: 0
    t.integer  "year"
    t.boolean  "fix"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "deadline",   default: "2999-12-31 23:59:59"
  end

  create_table "updates", force: :cascade do |t|
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "repbody_id"
    t.string   "date"
  end

  create_table "usercomments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "repbody_id"
    t.integer  "comment_id"
    t.date     "date"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "account"
    t.string   "username"
    t.string   "studentid"
    t.string   "email"
    t.integer  "role_id"
    t.string   "grade"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "machine"
    t.integer  "year",            default: 2013
    t.boolean  "acception"
    t.string   "owner"
    t.string   "furigana",        default: "family first"
    t.string   "avatar"
  end

  create_table "years", force: :cascade do |t|
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default"
  end

end
