# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_190_509_173_838) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'frames', force: :cascade do |t|
    t.bigint 'game_id'
    t.integer 'number', limit: 2
    t.integer 'points', limit: 2, default: 0
    t.bigint 'frame_id'
    t.boolean 'spare', default: false
    t.boolean 'strike', default: false
    t.boolean 'ended', default: false
    t.index ['frame_id'], name: 'index_frames_on_frame_id'
    t.index ['game_id'], name: 'index_frames_on_game_id'
  end

  create_table 'games', force: :cascade do |t|
    t.string 'player_name', null: false
  end

  create_table 'rolls', force: :cascade do |t|
    t.integer 'points', limit: 2
    t.integer 'number', limit: 2
    t.bigint 'frames_id'
    t.index ['frames_id'], name: 'index_rolls_on_frames_id'
  end
end
