# frozen_string_literal: true

module Util
  class Theme
    attr_reader :key

    def initialize(key: nil)
      @key = key || Settings.application.theme.to_s
    end

    def application_stylesheet_asset_path
      @application_stylesheet_asset_path ||= (Pathname.new('themes') + key).to_s + '/application'
    end

    def application_stylesheet_path
      @application_stylesheet_path ||= dir.to_s + '/application.scss'
    end

    def dir
      @dir ||= Rails.root + 'app/assets/stylesheets/themes' + key
    end

    def exists?
      return false if key.blank?
      return false unless dir.directory?

      Dir[dir.to_s + '/application.*'].any?
    end

    def validate!
      return if key.blank?
      raise "Theme does note exist: #{application_stylesheet_path}" unless exists?
    end

    def self.all_application_stylesheet_asset_paths
      @all_application_stylesheet_asset_paths ||= begin
        ret = []
        (Rails.root + 'app/assets/stylesheets/themes').children.each do |child|
          next unless child.directory?

          ret << child.to_s + 'application'
        end
        ret
      end
    end

    def self.validate!
      new.validate!
    end
  end
end
