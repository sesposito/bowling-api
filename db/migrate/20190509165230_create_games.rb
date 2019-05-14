# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :player_name, null: false
      t.boolean :ended, default: false
      t.integer :current_frame_number, null: false
    end
  end
end
