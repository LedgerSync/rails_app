# frozen_string_literal: true

require 'rails_helper'
support :klass_helpers,
        :routing_helpers,
        :settings_helpers

describe 'Settings.customizations' do
  include Capybara::DSL
  include KlassHelpers
  include RoutingHelpers
  include SettingsHelpers

  describe '.before_application_css_urls', js: true, type: :feature do
    def expect_before_application_css_urls(*urls)
      with_settings(customization: { before_application_css_urls: urls }) do
        expect(Settings.customization.before_application_css_urls).to eq(urls)
        visit(r.root_path)
        urls.each do |url|
          expect_css_link(url)
        end
      end
    end

    it do
      expect_before_application_css_urls 'https://example.com/1'
    end

    it do
      expect_before_application_css_urls 'https://example.com/1', 'https://example.com/2'
    end
  end
end
