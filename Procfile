web: bundle exec unicorn -p $PORT
worker: bundle exec sidekiq -c 5 -v -q resource_worker
