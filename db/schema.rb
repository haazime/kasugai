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

ActiveRecord::Schema.define(version: 20171107050129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "issues", id: :string, force: :cascade do |t|
    t.string "project_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "project_members", force: :cascade do |t|
    t.string "project_id", null: false
    t.bigint "user_id", null: false
    t.index ["project_id", "user_id"], name: "index_project_members_on_project_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_project_members_on_user_id"
  end

  create_table "projects", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sign_ins", force: :cascade do |t|
    t.string "token", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.index ["email"], name: "index_sign_ins_on_email", unique: true
    t.index ["token"], name: "index_sign_ins_on_token", unique: true
  end

  create_table "sign_ups", force: :cascade do |t|
    t.string "token", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.index ["email"], name: "index_sign_ups_on_email", unique: true
    t.index ["token"], name: "index_sign_ups_on_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "initials", null: false
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "issues", "projects"
  add_foreign_key "issues", "users"
  add_foreign_key "project_members", "projects"
  add_foreign_key "project_members", "users"
end
