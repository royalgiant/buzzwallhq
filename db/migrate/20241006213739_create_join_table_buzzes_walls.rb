class CreateJoinTableBuzzesWalls < ActiveRecord::Migration[7.0]
  def change
    create_table :buzzes_walls, id: false do |t|
      t.belongs_to :buzz, null: false, foreign_key: { to_table: :buzzes }
      t.belongs_to :wall, null: false, foreign_key: true

      t.index [:buzz_id, :wall_id]
      t.index [:wall_id, :buzz_id]
    end
  end
end
