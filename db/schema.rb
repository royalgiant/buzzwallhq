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

ActiveRecord::Schema[7.0].define(version: 2024_09_26_143124) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buzz_terms", force: :cascade do |t|
    t.string "term", null: false
    t.bigint "user_id", null: false
    t.string "frequency_check", default: "daily", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_buzz_terms_on_user_id"
  end

  create_table "buzzs", force: :cascade do |t|
    t.string "url", null: false
    t.bigint "wall_id"
    t.string "thumbnail_url", null: false
    t.bigint "user_id", null: false
    t.boolean "approved"
    t.bigint "buzz_term_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buzz_term_id"], name: "index_buzzs_on_buzz_term_id"
    t.index ["user_id"], name: "index_buzzs_on_user_id"
    t.index ["wall_id"], name: "index_buzzs_on_wall_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "stripe_id"
    t.string "avatar_url"
    t.string "provider"
    t.string "uid"
    t.string "full_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "walls", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.bigint "buzz_term_id"
    t.string "iframe_url"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buzz_term_id"], name: "index_walls_on_buzz_term_id"
    t.index ["user_id"], name: "index_walls_on_user_id"
  end

  add_foreign_key "buzz_terms", "users"
  add_foreign_key "buzzs", "buzz_terms"
  add_foreign_key "buzzs", "users"
  add_foreign_key "buzzs", "walls"
  add_foreign_key "walls", "buzz_terms"
  add_foreign_key "walls", "users"
end
