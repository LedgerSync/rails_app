# == Schema Information
#
# Table name: ledgers
#
#  id              :string           not null, primary key
#  access_token    :string
#  connected_by    :string
#  data            :jsonb
#  disconnected_at :datetime
#  disconnected_by :string
#  expires_at      :datetime
#  kind            :string
#  refresh_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :string
#
# Indexes
#
#  index_ledgers_on_connected_by     (connected_by)
#  index_ledgers_on_disconnected_at  (disconnected_at)
#  index_ledgers_on_disconnected_by  (disconnected_by)
#  index_ledgers_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (connected_by => users.id)
#  fk_rails_...  (disconnected_by => users.id)
#  fk_rails_...  (organization_id => organizations.id)
#

require 'rails_helper'

RSpec.describe Ledger, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
