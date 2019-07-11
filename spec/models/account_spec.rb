# == Schema Information
#
# Table name: accounts
#
#  id          :string           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string
#
# Indexes
#
#  index_accounts_on_external_id  (external_id) UNIQUE
#

require 'rails_helper'

RSpec.describe Account, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
