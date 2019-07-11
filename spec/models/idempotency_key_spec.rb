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

require 'rails_helper'

RSpec.describe IdempotencyKey, type: :model do
  let(:idempotency_key) { create(:idempotency_key) }

  describe '#response_data' do
    subject { idempotency_key.response_data }

    it { is_expected.to be_a(Hash) }
  end
end
