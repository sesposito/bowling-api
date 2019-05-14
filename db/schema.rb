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

ActiveRecord::Schema.define(version: 2019_05_09_173838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "frames", force: :cascade do |t|
    t.bigint "game_id"
    t.integer "number", limit: 2, null: false
    t.integer "points", limit: 2, default: 0
    t.boolean "spare", default: false
    t.boolean "strike", default: false
    t.boolean "ended", default: false
    t.integer "bonus_throws", limit: 2, default: 0
    t.index ["game_id"], name: "index_frames_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "player_name", null: false
    t.boolean "ended", default: false
    t.integer "current_frame_number", null: false
  end

  create_table "throws", force: :cascade do |t|
    t.integer "points", limit: 2
    t.integer "number", limit: 2
    t.bigint "frame_id"
    t.bigint "game_id"
    t.index ["frame_id"], name: "index_throws_on_frame_id"
    t.index ["game_id"], name: "index_throws_on_game_id"
  end

end
