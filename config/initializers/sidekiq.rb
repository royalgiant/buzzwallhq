# config/initializers/sidekiq.rb

require 'sidekiq'
require 'sidekiq-cron'

sidekiq_config = YAML.load_file(Rails.root.join('config', 'sidekiq.yml'))

schedule_file = sidekiq_config.dig(:schedule, :schedule_file)

if schedule_file && File.exist?(Rails.root.join(schedule_file)) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(Rails.root.join(schedule_file))
end