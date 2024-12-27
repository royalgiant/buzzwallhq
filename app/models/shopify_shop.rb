class ShopifyShop < ApplicationRecord
  validates :shopify_domain, :shopify_access_token, :shopify_email, presence: true
  belongs_to :user, optional: true
end