# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Events::ScheduleRetry, type: :form do
  include Formify::SpecHelpers


  let(:event) { FactoryBot.create(:event) }


  let(:attributes) do
    {
      event: event
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Event) }

  describe '#event' do
    it { expect_error_with_missing_attribute(:event) }
    xit { expect_error_with_attribute_value(:event, EVENT_BAD_VALUE, message: nil) } # :message is optional
    xit { expect_valid_with_attribute_value(:event, EVENT_GOOD_VALUE) }
  end

end
