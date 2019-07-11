require 'rails_helper'

describe Resonad do
  it do
    expect(
      Resonad.Success('test')
        .raise_if_error
    ).to be_success
  end

  it do
    expect {
      Resonad.Failure(StandardError)
        .raise_if_error
    }.to raise_error(StandardError)
  end
end