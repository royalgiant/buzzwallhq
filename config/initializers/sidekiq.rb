# config/initializers/sidekiq.rb
require 'sidekiq'
require 'sidekiq-cron'

redis_url = Rails.application.credentials.dig(Rails.env.to_sym, :redis_url) || ENV['REDIS_URL']
Rails.logger.info("Sidekiq REDIS_URL: #{redis_url}")
redis_config = Rails.env.development? ? { url: "redis://redis:6379/1" } : { url: redis_url }
Rails.logger.info("Sidekiq rails_config: #{redis_config}")
Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

sidekiq_config = YAML.load_file(Rails.root.join('config', 'sidekiq.yml'))

schedule_file = sidekiq_config.dig(:schedule, :schedule_file)

if schedule_file && File.exist?(Rails.root.join(schedule_file)) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(Rails.root.join(schedule_file))
end