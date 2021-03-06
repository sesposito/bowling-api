# frozen_string_literal: true

class CreateFrames < ActiveRecord::Migration[5.2]
  def change
    create_table :frames do |t|
      t.references :game
      t.integer :number, limit: 2, null: false
      t.integer :points, limit: 2, default: 0
      t.boolean :spare, default: false
      t.boolean :strike, default: false
      t.boolean :ended, default: false
      t.integer :bonus_throws, limit: 2, default: 0
    end
  end
end
