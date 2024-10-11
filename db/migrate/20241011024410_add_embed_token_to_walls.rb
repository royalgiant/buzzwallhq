class AddEmbedTokenToWalls < ActiveRecord::Migration[7.0]
  def change
    add_column :walls, :embed_token, :string
    add_index :walls, :embed_token, unique: true
  end
end
