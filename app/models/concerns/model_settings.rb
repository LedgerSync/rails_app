# frozen_string_literal: true

module ModelSettings
  extend ActiveSupport::Concern

  included do
    has_paper_trail if: proc { |_t| Settings.add_ons.paper_trail.enabled }
  end
end
