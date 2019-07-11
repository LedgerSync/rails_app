# frozen_string_literal: true

require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true

  c.default_cassette_options = { match_requests_on: [:body], record: :new_episodes }

  c.ignore_localhost = true

  c.ignore_hosts(
    'chromedriver.storage.googleapis.com',
    'developer.microsoft.com/en-us/microsoft-edge/tools/webdriver',
    'github.com/mozilla/geckodriver/releases',
    'lvh.me',
    'selenium-release.storage.googleapis.com'
  )

  Rails.application.secrets.each do |key, _value|
    c.filter_sensitive_data("<#{key.to_s.upcase}>") { Rails.application.secrets.send(key) }
  end
end
