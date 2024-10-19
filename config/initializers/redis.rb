# config/initializers/redis.rb
Rails.logger.info("Rails.env.production?: #{Rails.env.production?}")
redis_url = Rails.application.credentials.dig(Rails.env.to_sym, :redis_url) || ENV['REDIS_URL']
Rails.logger.info("ENV['REDIS_URL']: #{redis_url}")
if Rails.env.production? && redis_url.present?
  Rails.logger.info("Redis is in production")
  uri = URI.parse(redis_url)
  Redis.current = Redis.new(url: redis_url)
else
  Rails.logger.info("Redis is in development")
  Redis.current = Redis.new(host: 'localhost', port: 6379, db: 0)
end
