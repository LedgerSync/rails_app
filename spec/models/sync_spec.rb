# == Schema Information
#
# Table name: syncs
#
#  id                   :string           not null, primary key
#  operation_method     :string
#  position             :integer          not null
#  references           :jsonb
#  resource_type        :string
#  status               :integer          default("blocked"), not null
#  status_message       :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :string
#  resource_external_id :string
#  resource_id          :string
#
# Indexes
#
#  index_syncs_on_account_id   (account_id)
#  index_syncs_on_resource_id  (resource_id)
#  index_syncs_on_status       (status)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (resource_id => resources.id)
#

require 'rails_helper'

describe Sync, type: :model do
  let(:sync) { FactoryBot.create(:sync) }

  describe '#next_sync' do
    context 'when no next_sync' do
      it { expect(sync.next_sync).to be_nil }
    end

    context 'when no next_sync' do
      let(:next_sync) { FactoryBot.create(:sync, account: sync.account) }

      before do
        sync.reload
        next_sync
      end

      it { expect(sync.next_sync).to eq(next_sync) }
    end
  end
end
