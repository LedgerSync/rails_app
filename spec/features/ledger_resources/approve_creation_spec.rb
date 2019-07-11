require 'rails_helper'

support :search_helpers

describe 'customers/search', type: :feature, js: true do
  let(:ledger_resource) { FactoryBot.create(:ledger_resource, resource_ledger_id: nil) }

  def approve_creation
    expect(ledger_resource).not_to be_approved
    login
    visit r.ledger_resource_path(ledger_resource)
    click_on t('ledger_resources.create_btn')
    accept_alert
  end

  it do
    approve_creation
    expect_content t('ledger_resources.approved_for_creation')
    expect(ledger_resource.reload).to be_approved
  end

  it do
    message = 'test'
    error = StandardError.new(message)
    allow_any_instance_of(Forms::LedgerResources::ApproveCreation).to receive(:save) { Resonad.Failure(error) }
    approve_creation
    expect_content message
    expect(ledger_resource.reload).not_to be_approved
  end
end
