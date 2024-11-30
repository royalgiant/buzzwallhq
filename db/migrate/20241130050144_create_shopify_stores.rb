class CreateShopifyStores < ActiveRecord::Migration[7.1]
  def change
    create_table :shopify_stores do |t|
      t.string :shop_domain, null: false
      t.string :access_token
      t.string :embed_token
      t.belongs_to :user # Association with your existing users table
      t.timestamps
    end
    
    add_index :shopify_stores, :shop_domain, unique: true
  end
end
