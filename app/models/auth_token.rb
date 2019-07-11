# == Schema Information
#
# Table name: auth_tokens
#
#  id         :string           not null, primary key
#  used_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :string
#
# Indexes
#
#  index_auth_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class AuthToken < ApplicationRecord
  include Serializable
  include Identifiable

  API_OBJECT = 'auth_token'.freeze
  ID_PREFIX = 'at'.freeze

  belongs_to :user

  scope :not_used, -> { where(used_at: nil) }
  scope :used, -> { where.not(used_at: nil) }

  def expired?
    created_at < (Time.zone.now - Settings.authentication.auth_token_valid_for_minutes.minutes)
  end

  def used?
    used_at.present?
  end
end
