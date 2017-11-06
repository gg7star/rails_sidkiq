require 'sidekiq'
require 'sidekiq/scheduler'

# Sidekiq.configure_server do |config|
#   config.error_handlers << Proc.new { |ex,ctx_hash| Airbrake.notify(ex, ctx_hash) }
#   config.redis = { url: 'redis://localhost:6379/1' }
# end

# Sidekiq.configure_client do |config|
#   config.redis = { url: 'redis://localhost:6379/1' }
# end

# Sidekiq.schedule = YAML.load_file(File.expand_path('../../../config/schedul.yml',__FILE__))
# Sidekiq::Scheduler.load_schedule! # This will retrigger the loading stage 

Sidekiq.configure_server do |config|
	if Rails.env.production?
	  host = 'redis://redistogo:003f8ea14834b75879e272760230d700@barreleye.redistogo.com'
	  port = 6379
	  config.redis = Redis::Namespace.new('rails_sidekiq',
	                                :redis => Redis.new(:url => host, :port=> port))
	else
	  config.redis = Redis::Namespace.new('rails_sidekiq',
	                                :redis => Redis.new)
	end
end

rails_root = File.dirname(__FILE__) + '/../..'
schedule_file = rails_root + "/config/schedule.yml"
puts "============== Loading #{schedule_file} ====================="
if File.exists?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
