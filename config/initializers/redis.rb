# config/initializers/redis.rb
if Rails.env.production? && ENV["REDIS_URL"].present?
  uri = URI.parse(ENV["REDIS_URL"])
  Redis.current = Redis.new(url: ENV["REDIS_URL"])
else
  Redis.current = Redis.new(host: 'localhost', port: 6379, db: 0)
end
