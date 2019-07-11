# frozen_string_literal: true

require 'rails_helper'

describe Util::QuickBooksOnline do
  subject { described_class.new }

  describe '.grant_url' do
    subject { described_class.grant_url }

    it { is_expected.to include('http') }
  end

  describe '.oauth_client' do
    subject { described_class.oauth_client }

    it { is_expected.to be_a(OAuth2::Client) }
  end
end
