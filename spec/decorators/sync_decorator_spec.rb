require 'rails_helper'

RSpec.describe SyncDecorator do
  let(:sync) { create(:sync) }
  describe '#status_color' do
    subject do
      sync.update!(status: status)
      sync.decorate.status_color
    end

    let(:status) { nil }

    context 'when status=:blocked' do
      let(:status) { :blocked }

      it { expect(subject).to eq(:warning) }
    end

    context 'when status=:failed' do
      let(:status) { :failed }

      it { expect(subject).to eq(:danger) }
    end

    context 'when status=:succeeded' do
      let(:status) { :succeeded }

      it { expect(subject).to eq(:success) }
    end

    context 'when status=:queued' do
      let(:status) { :queued }

      it { expect(subject).to eq(:secondary) }
    end
  end
end
