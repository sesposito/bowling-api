# frozen_string_literal: true

class CreateThrows < ActiveRecord::Migration[5.2]
  def change
    create_table :throws do |t|
      t.integer :points, limit: 2
      t.integer :number, limit: 1
      t.references :frame
      t.references :game
    end
  end
end
