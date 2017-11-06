Rails Sidkiq
================

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

Rails Composer is supported by developers who purchase our RailsApps tutorials.

Problems? Issues?
-----------

Need help? Ask on Stack Overflow with the tag 'railsapps.'

Your application contains diagnostics in the README file. Please provide a copy of the README file when reporting any issues.

If the application doesn't work as expected, please [report an issue](https://github.com/RailsApps/rails_apps_composer/issues)
and include the diagnostics.

Ruby on Rails
-------------

This application requires:

- Ruby 2.3.1
- Rails 5.1.4

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Getting Started
---------------
> bundle install

> rails s

On other console window, run this command

> bundle exec sidekiq -q resource_worker


Documentation and Support
-------------------------

## Gemfile

gem 'sidekiq-scheduler'


## config/initializers/sidekiq_scheduler.rb

require 'sidekiq/scheduler'

Sidekiq.configure_server do |config| 
	config.redis = { url: 'redis://localhost:6390/0' } 
end

Sidekiq.configure_client do |config| 
	config.redis = { url: 'redis://localhost:6390/0' }
end

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path('../../../config/scheduler.yml',__FILE__))
    Sidekiq::Scheduler.load_schedule! # This will retrigger the loading stage 
  end
end


## config/application.rb

...
config.active_job.queue_adapter = :sidekiq


## app/workers/resource_worker.rb

require 'sidekiq-scheduler'

class ResourceWorker
	include Sidekiq::Worker
  #sidekiq_options queue: "high"

	def perform
    users = User.all
    users.each do |user|
    	user.wood += 3
    	user.save
  	end

	end
end


## config/scheduler.yml
resource_worker:
  # cron: "1 * * * *"
  class: ResourceWorker
  every: '1m'
  queue: resource_worker


## config/initializers/redis.rb

redis = Hash.new{|h, k| h[k] = Hash.new(url: ENV["REDIS_URL"].presence || "redis://localhost:6379")}

redis["production"] = {url: ENV["REDIS_URL"].presence || "redis://localhost:6390"}
redis["staging"] = {url: ENV["REDIS_URL"].presence || "redis://localhost:6390"}
redis["development"] = {url: "redis://localhost:6390"}
redis["test"] = {url: "redis://localhost:6391"}

uri = URI.parse(redis.dig(Rails.env, :url))

if Rails.env.development? || Rails.env.test?
  system("redis-server --port #{uri.port} --daemonize yes")
  raise "Couldn't start redis" if $?.exitstatus != 0
end

REDIS = Redis.new(url: uri.to_s, port: uri.port).freeze
puts ">> Initialized REDIS with #{REDIS.inspect}"


## config.ru

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

run Sidekiq::Web

## config/routes.rb

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
	...

	mount Sidekiq::Web, at: '/sidekiq'
end


Issues
-------------

Similar Projects
----------------

Contributing
------------

Credits
-------

License
-------
