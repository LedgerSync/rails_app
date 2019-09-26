# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeveloperMailer, type: :mailer do
  describe 'webhook_failure' do
    let(:event) { FactoryBot.create(:event) }
    let(:mail) { described_class.webhook_failure(event.id) }

    it 'renders the headers' do
      expect(mail.subject).to include('Webhook failure at ')
      expect(mail.to).to eq(['test@example.com'])
      expect(mail.from).to eq(['no-reply-test@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include("Event ID: #{event.id}")
    end
  end
end
