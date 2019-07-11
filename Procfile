web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q mailers -c ${SIDEKIQ_CONCURRENCY:-5}
clock: bundle exec sidekiq -r ./hello-scheduler.rb
