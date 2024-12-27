# config/initializers/shopify_api.rb
ShopifyAPI::Context.setup(
  api_key: Rails.application.credentials.dig(Rails.env.to_sym, :shopify, :api_key),
  api_secret_key: Rails.application.credentials.dig(Rails.env.to_sym, :shopify, :api_secret),
  host: Rails.env.development? ? 'https://engaged-dane-accepted.ngrok-free.app' : 'https://buzzwallhq.com',
  scope: ['write_products', 'read_products'], # Add any scopes you need
  is_embedded: true, # Since you're using an embedded app
  is_private: false, # This is a public app
  api_version: '2024-01' # Use current API version
)