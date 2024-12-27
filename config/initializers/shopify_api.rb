# config/initializers/shopify_api.rb

Rails.logger.info("SHOP is in #{Rails.env}")
if Rails.env.development?
  api_key = Rails.application.credentials.dig(Rails.env.to_sym, :shopify, :api_key)
  api_secret = Rails.application.credentials.dig(Rails.env.to_sym, :shopify, :api_secret)
else
  api_key = ENV['SHOPIFY_API_KEY']
  api_secret = ENV['SHOPIFY_API_SECRET']
end

if !defined?(Rake) || !Rake.application.top_level_tasks.include?('assets:precompile')
  ShopifyAPI::Context.setup(
    api_key: api_key,
    api_secret_key: api_secret,
    host: Rails.env.development? ? 'https://engaged-dane-accepted.ngrok-free.app' : 'https://buzzwallhq.com',
    scope: ['write_products', 'read_products'],
    is_embedded: true,
    is_private: false,
    api_version: '2024-01'
  )
end