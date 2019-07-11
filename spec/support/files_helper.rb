# frozen_string_literal: true

module FilesHelper
  extend ActiveSupport::Concern

  included do
    def image_fixture
      fixture_file_upload(
        image_path,
        'image/png'
      )
    end

    def image_path
      Rails.root.join(
        'spec',
        'support',
        'files',
        'test.png'
      )
    end
  end
end
