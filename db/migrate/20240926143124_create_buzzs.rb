class CreateBuzzs < ActiveRecord::Migration[7.0]
  def change
    create_table :buzzs do |t|
      t.string :url, null: false
      t.references :wall, foreign_key: true
      t.string :thumbnail_url, null: false
      t.references :user, null: false, foreign_key: true
      t.boolean :approved
      t.references :buzz_term, null: false, foreign_key: true

      t.timestamps
    end
  end
end
