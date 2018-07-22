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

ActiveRecord::Schema.define(version: 2018_07_21_150736) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_passages", force: :cascade do |t|
    t.bigint "course_id"
    t.string "educable_type"
    t.bigint "educable_id"
    t.boolean "passed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_passages_on_course_id"
    t.index ["educable_type", "educable_id"], name: "index_course_passages_on_educable_type_and_educable_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "user_id"
    t.text "decoration_description", default: ""
    t.integer "level", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "lesson_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "lessons_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "lessons_desc_idx"
  end

  create_table "lesson_passages", force: :cascade do |t|
    t.bigint "lesson_id"
    t.string "educable_type"
    t.bigint "educable_id"
    t.boolean "passed", default: false
    t.bigint "course_passage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "available", default: false
    t.index ["course_passage_id"], name: "index_lesson_passages_on_course_passage_id"
    t.index ["educable_type", "educable_id"], name: "index_lesson_passages_on_educable_type_and_educable_id"
    t.index ["lesson_id"], name: "index_lesson_passages_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "user_id"
    t.string "title", null: false
    t.text "ideas", default: ""
    t.text "summary", default: ""
    t.text "check_yourself", default: ""
    t.integer "order", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.index ["course_id"], name: "index_lessons_on_course_id"
    t.index ["user_id"], name: "index_lessons_on_user_id"
  end

  create_table "materials", force: :cascade do |t|
    t.bigint "lesson_id"
    t.bigint "user_id"
    t.string "title"
    t.text "body"
    t.text "summary"
    t.integer "order", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_materials_on_lesson_id"
    t.index ["user_id"], name: "index_materials_on_user_id"
  end

  create_table "quest_groups", force: :cascade do |t|
    t.bigint "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_quest_groups_on_lesson_id"
  end

  create_table "quest_passages", force: :cascade do |t|
    t.bigint "quest_id"
    t.bigint "lesson_passage_id"
    t.boolean "passed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_passage_id"], name: "index_quest_passages_on_lesson_passage_id"
    t.index ["quest_id"], name: "index_quest_passages_on_quest_id"
  end

  create_table "quests", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "description"
    t.integer "level", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lesson_id"
    t.bigint "quest_group_id"
    t.integer "old_quest_group_id"
    t.text "body"
    t.index ["lesson_id"], name: "index_quests_on_lesson_id"
    t.index ["old_quest_group_id"], name: "index_quests_on_old_quest_group_id"
    t.index ["quest_group_id"], name: "index_quests_on_quest_group_id"
    t.index ["user_id"], name: "index_quests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", default: "User", null: false
    t.string "name", null: false
    t.string "surname", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "course_passages", "courses"
  add_foreign_key "courses", "users"
  add_foreign_key "lesson_passages", "course_passages"
  add_foreign_key "lesson_passages", "lessons"
  add_foreign_key "lessons", "courses"
  add_foreign_key "lessons", "users"
  add_foreign_key "materials", "lessons"
  add_foreign_key "materials", "users"
  add_foreign_key "quest_groups", "lessons"
  add_foreign_key "quest_passages", "lesson_passages"
  add_foreign_key "quest_passages", "quests"
  add_foreign_key "quests", "lessons"
  add_foreign_key "quests", "quest_groups"
  add_foreign_key "quests", "users"
end
