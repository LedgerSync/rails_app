# frozen_string_literal: true

require 'rails_helper'

describe Util::Router do
  subject { described_class.new }

  it { expect(subject).to respond_to(:login_url) }

  context 'when test=true' do
    subject { described_class.new(test: true) }

    it { expect(subject).not_to respond_to(:login_url) }
  end
end
