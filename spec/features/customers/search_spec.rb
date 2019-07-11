require 'rails_helper'

support :search_helpers

describe 'customers/search', type: :feature, js: true do
  include SearchHelpers

  let(:search_customers) { lib_customers }
  let(:user) { FactoryBot.create(:user) }
  let(:sync_resource) { FactoryBot.create(:sync_resource) }
  let(:resource) { sync_resource.resource}
  let(:ledger_resource) { FactoryBot.create(:ledger_resource, resource: resource) }

  it do
    allow_any_instance_of(
      Forms::LedgerResources::Search
    ).to(
      receive(:save).and_return(
        LedgerSync::SearchResult.Success(
          searcher: OpenStruct.new(
            next_searcher: nil,
            previous_searcher: nil,
            resources: search_customers
          )
        )
      )
    )
    login(user)
    visit Util::Router.new.ledger_resource_assignments_path(ledger_resource)
    find(class: 'btn-assign', match: :first).click
    accept_alert
    expect_content t('ledger_resources.assign.success')
    expect(ledger_resource.reload.resource_ledger_id).to be_present
  end
end
