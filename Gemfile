# frozen_string_literal: true

# If new gem versions are found:
# 1. Add exact version to gem
# 2. run: `bundle install --full-index`

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.2'

gem 'awesome_print'
gem 'api-pagination'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap'
gem 'coffee-rails', '~> 4.2'
gem 'colorize'
gem 'config', github: 'ryanwjackson/config', branch: 'dry_validation_contracts'
gem 'draper'
gem 'faraday'
gem 'fast_jsonapi'
gem 'foreman'
gem 'formify'
gem 'haml-rails'
gem 'http'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'kaminari'
gem 'ledger_sync', '1.0.10'
gem 'lograge'
gem 'money-rails'
gem 'oauth2'
gem 'paper_trail'
gem 'pg'
gem 'premailer-rails'
gem 'puma', '~> 3.11'
gem 'rack-cors'
gem 'rails', '~> 5.2.3'
gem 'rails_warden'
gem 'redis', '~> 4.0'
gem 'resonad'
gem 'safely_block'
gem 'sassc-rails'
gem 'sentry-raven'
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 2.2'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'with_advisory_lock'

# Third Party Services
gem 'mailgun-ruby', '~>1.1.6'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'dotenv-rails', require: 'dotenv/rails-now'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'hookup'
  # gem 'ledger_sync', github: 'LedgerSync/ledger_sync', branch: 'master'
  gem 'letter_opener'
  gem 'rspec-rails', '>= 3.4.0'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'selenium-webdriver'
end

group :test do
  gem 'capybara', '>= 2.15' # Adds support for Capybara system testing and selenium driver
  gem 'capybara-screenshot'
  gem 'climate_control'
  gem 'database_cleaner'
  gem 'mock_redis'
  gem 'rspec_junit_formatter'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'vcr'
  gem 'webdrivers'
  gem 'webmock'
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'guard-rspec', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'overcommit'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
