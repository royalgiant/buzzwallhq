class CreateBuzzes < ActiveRecord::Migration[7.0]
  def change
    create_table :buzzes do |t|
      t.string :url, null: false
      t.string :thumbnail_url, null: false
      t.references :user, null: false, foreign_key: true
      t.boolean :approved
      t.references :buzz_term, null: false, foreign_key: true
      t.string :video_id
      t.string :title
      t.integer :play_count
      t.integer :comment_count
      t.integer :share_count
      t.datetime :create_time
      t.json :author

      t.timestamps
    end
  end
end
