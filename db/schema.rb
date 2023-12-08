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

ActiveRecord::Schema.define(version: 2023_12_08_060553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.integer "winning_team_id"
    t.integer "losing_team_id"
    t.integer "winning_team_score"
    t.integer "losing_team_score"
    t.datetime "played_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["losing_team_id", "played_at"], name: "index_matches_on_losing_team_id_and_played_at"
    t.index ["winning_team_id", "played_at"], name: "index_matches_on_winning_team_id_and_played_at"
  end

  create_table "player_matches", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "match_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_player_matches_on_match_id"
    t.index ["player_id"], name: "index_player_matches_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "admin", default: false
    t.boolean "active", default: true
    t.string "password_digest"
    t.string "remember_digest"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_players_on_email", unique: true
    t.index ["name"], name: "index_players_on_name"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "player_one_id"
    t.integer "player_two_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_one_id", "player_two_id"], name: "index_teams_on_player_one_id_and_player_two_id", unique: true
    t.index ["player_one_id"], name: "index_teams_on_player_one_id"
    t.index ["player_two_id"], name: "index_teams_on_player_two_id"
  end

  add_foreign_key "matches", "teams", column: "losing_team_id"
  add_foreign_key "matches", "teams", column: "winning_team_id"
  add_foreign_key "player_matches", "matches"
  add_foreign_key "player_matches", "players"
  add_foreign_key "teams", "players", column: "player_one_id"
  add_foreign_key "teams", "players", column: "player_two_id"
end
