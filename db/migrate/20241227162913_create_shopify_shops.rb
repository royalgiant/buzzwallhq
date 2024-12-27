class CreateShopifyShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shopify_shops do |t|
      t.string :shopify_domain
      t.string :shopify_access_token 
      t.string :shopify_gid
      t.string :shopify_email
      t.references :user, null: true, foreign_key: { on_delete: :cascade }
      t.timestamps
    end
    
    add_index :shopify_shops, :shopify_gid
  end
end
