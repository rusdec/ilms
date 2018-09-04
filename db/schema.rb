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

ActiveRecord::Schema.define(version: 2018_09_03_195027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges", force: :cascade do |t|
    t.string "title", null: false
    t.string "description", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "badgable_type"
    t.bigint "badgable_id"
    t.bigint "course_id"
    t.boolean "hidden", default: false
    t.index ["badgable_type", "badgable_id"], name: "index_badges_on_badgable_type_and_badgable_id"
    t.index ["course_id"], name: "index_badges_on_course_id"
    t.index ["user_id"], name: "index_badges_on_user_id"
  end

  create_table "course_knowledges", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "knowledge_id"
    t.integer "percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "knowledge_id"], name: "index_course_knowledges_on_course_id_and_knowledge_id", unique: true
    t.index ["course_id"], name: "index_course_knowledges_on_course_id"
    t.index ["knowledge_id"], name: "index_course_knowledges_on_knowledge_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "user_id"
    t.text "decoration_description", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.integer "difficulty", default: 1, null: false
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "knowledge_areas", force: :cascade do |t|
    t.string "name"
    t.bigint "knowledge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["knowledge_id"], name: "index_knowledge_areas_on_knowledge_id"
  end

  create_table "knowledge_directions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_knowledge_directions_on_name", unique: true
  end

  create_table "knowledges", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "knowledge_direction_id"
    t.index ["knowledge_direction_id"], name: "index_knowledges_on_knowledge_direction_id"
    t.index ["name"], name: "index_knowledges_on_name", unique: true
  end

  create_table "lesson_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "lessons_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "lessons_desc_idx"
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
    t.integer "difficulty", default: 1, null: false
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

  create_table "passage_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "passage_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "passage_desc_idx"
  end

  create_table "passage_solutions", force: :cascade do |t|
    t.bigint "passage_id"
    t.text "body"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["passage_id"], name: "index_passage_solutions_on_passage_id"
    t.index ["status_id"], name: "index_passage_solutions_on_status_id"
  end

  create_table "passages", force: :cascade do |t|
    t.string "passable_type"
    t.bigint "passable_id"
    t.bigint "user_id"
    t.integer "parent_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["passable_type", "passable_id"], name: "index_passages_on_passable_type_and_passable_id"
    t.index ["status_id"], name: "index_passages_on_status_id"
    t.index ["user_id"], name: "index_passages_on_user_id"
  end

  create_table "quest_groups", force: :cascade do |t|
    t.bigint "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_quest_groups_on_lesson_id"
  end

  create_table "quests", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lesson_id"
    t.bigint "quest_group_id"
    t.integer "old_quest_group_id"
    t.text "body"
    t.integer "difficulty", default: 1, null: false
    t.index ["lesson_id"], name: "index_quests_on_lesson_id"
    t.index ["old_quest_group_id"], name: "index_quests_on_old_quest_group_id"
    t.index ["quest_group_id"], name: "index_quests_on_quest_group_id"
    t.index ["user_id"], name: "index_quests_on_user_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_statuses_on_name", unique: true
  end

  create_table "user_grantables", force: :cascade do |t|
    t.bigint "user_id"
    t.string "grantable_type"
    t.bigint "grantable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grantable_type", "grantable_id"], name: "index_user_grantables_on_grantable_type_and_grantable_id"
    t.index ["user_id"], name: "index_user_grantables_on_user_id"
  end

  create_table "user_knowledges", force: :cascade do |t|
    t.string "user_type"
    t.bigint "user_id"
    t.bigint "knowledge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level", default: 1
    t.integer "experience", default: 0, null: false
    t.index ["knowledge_id"], name: "index_user_knowledges_on_knowledge_id"
    t.index ["user_id", "knowledge_id"], name: "index_user_knowledges_on_user_id_and_knowledge_id", unique: true
    t.index ["user_type", "user_id"], name: "index_user_knowledges_on_user_type_and_user_id"
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
    t.string "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "badges", "courses"
  add_foreign_key "badges", "users"
  add_foreign_key "course_knowledges", "courses"
  add_foreign_key "course_knowledges", "knowledges"
  add_foreign_key "courses", "users"
  add_foreign_key "knowledge_areas", "knowledges"
  add_foreign_key "knowledges", "knowledge_directions"
  add_foreign_key "lessons", "courses"
  add_foreign_key "lessons", "users"
  add_foreign_key "materials", "lessons"
  add_foreign_key "materials", "users"
  add_foreign_key "passage_solutions", "passages"
  add_foreign_key "passages", "users"
  add_foreign_key "quest_groups", "lessons"
  add_foreign_key "quests", "lessons"
  add_foreign_key "quests", "quest_groups"
  add_foreign_key "quests", "users"
  add_foreign_key "user_grantables", "users"
  add_foreign_key "user_knowledges", "knowledges"
end
