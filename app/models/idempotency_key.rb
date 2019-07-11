# == Schema Information
#
# Table name: idempotency_keys
#
#  id              :bigint(8)        not null, primary key
#  key             :string
#  request_body    :jsonb
#  response_body   :jsonb
#  response_status :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  request_id      :string
#
# Indexes
#
#  index_idempotency_keys_on_key         (key)
#  index_idempotency_keys_on_request_id  (request_id)
#

class IdempotencyKey < ApplicationRecord
  def response_data
    {
      json: response_body,
      status: response_status
    }
  end
end
