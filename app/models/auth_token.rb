# == Schema Information
#
# Table name: auth_tokens
#
#  id            :string           not null, primary key
#  resource_type :string
#  used_at       :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :string
#
# Indexes
#
#  index_auth_tokens_on_resource_id                    (resource_id)
#  index_auth_tokens_on_resource_id_and_resource_type  (resource_id,resource_type)
#

class AuthToken < ApplicationRecord
  include Serializable
  include Identifiable

  API_OBJECT = 'auth_token'.freeze
  ID_PREFIX = 'at'.freeze

  belongs_to  :resource,
              polymorphic: true

  validates :resource_type,
            inclusion: {
              in: %w[Organization User]
            }

  scope :not_used, -> { where(used_at: nil) }
  scope :used, -> { where.not(used_at: nil) }

  def expired?
    created_at < (Time.zone.now - Settings.authentication.auth_token_valid_for_minutes.minutes)
  end

  def used?
    used_at.present?
  end
end
