# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_26_025257) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "magic_link_sent_at"
    t.string "magic_link_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["magic_link_token"], name: "index_admins_on_magic_link_token", unique: true
  end

  create_table "assessments", force: :cascade do |t|
    t.bigint "stakeholder_id", null: false
    t.text "full_transcript"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "last_activity_at"
    t.index ["completed_at"], name: "index_assessments_on_completed_at"
    t.index ["stakeholder_id"], name: "index_assessments_on_stakeholder_id", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.text "custom_instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_companies_on_name"
  end

  create_table "stakeholders", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "email", null: false
    t.string "invitation_token", null: false
    t.bigint "company_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "invitation_sent_at"
    t.index ["company_id", "email"], name: "index_stakeholders_on_company_id_and_email", unique: true
    t.index ["company_id"], name: "index_stakeholders_on_company_id"
    t.index ["invitation_token"], name: "index_stakeholders_on_invitation_token", unique: true
    t.index ["status"], name: "index_stakeholders_on_status"
  end

  add_foreign_key "assessments", "stakeholders"
  add_foreign_key "stakeholders", "companies"
end
