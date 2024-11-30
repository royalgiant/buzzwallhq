class ShopifyStore < ApplicationRecord
  belongs_to :user
  validates :shop_domain, presence: true, uniqueness: true
  
  after_create :install_script_tag
  
  private
  
  def install_script_tag
    shop = ShopifyAPI::Shop.new(domain: shop_domain, token: access_token)
    ShopifyAPI::ScriptTag.create(
      shop: shop,
      event: 'onload',
      src: "https://buzzwallhq.com/shopify/embed.js?token=#{embed_token}"
    )
  end
end
