class CreateRolls < ActiveRecord::Migration[5.2]
  def change
    create_table :rolls do |t|
      t.integer :points, limit: 2
      t.integer :number, limit: 1
      t.references :frames
    end
  end
end
