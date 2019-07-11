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

FactoryBot.define do
  factory :idempotency_key do
    sequence(:key) { |n| "key_#{n}" }
    response_body { { a: 1, b: 2 } }
    response_status { 200 }
    sequence(:request_id) { |n| "request_id_#{n}" }
  end
end
