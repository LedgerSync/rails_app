# frozen_string_literal: true

require 'rails_helper'

describe Util::Router do
  subject { described_class.new }

  it { expect(subject).to respond_to(:login_url) }

  describe Util::Router::Test do
    subject { described_class }

    it { expect(subject).not_to respond_to(:login_url) }
  end
end
