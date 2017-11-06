require 'sidekiq/scheduler'

Sidekiq.configure_server do |config| 
	config.redis = { url: 'redis://localhost:6390/0' } 
end

Sidekiq.configure_client do |config| 
	config.redis = { url: 'redis://localhost:6390/0' }
end

# Sidekiq.schedule = YAML.load_file(File.expand_path('../../scheduler.yml', __FILE__))

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path('../../../config/scheduler.yml',__FILE__))
    Sidekiq::Scheduler.load_schedule! # This will retrigger the loading stage 
  end
end
