# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :player_name, null: false
      t.boolean :ended, default: false
    end
  end
end
