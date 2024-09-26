class CreateWalls < ActiveRecord::Migration[7.0]
  def change
    create_table :walls do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.references :buzz_term, foreign_key: true
      t.string :iframe_url
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
