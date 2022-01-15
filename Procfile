web: rm -rf tmp/pids/server.pid && bundle exec puma -C config/puma.rb -p 3000
log: tail -f log/development.log
worker: bundle exec sidekiq -c 2
