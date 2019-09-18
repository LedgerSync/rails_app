 # frozen_string_literal: true

require 'rails_helper'

describe Util::URLHelper do
  context '#merge_query' do
    it do
      h = described_class.new('https://example.com')
      expect(h.merge_query(foo: :bar).to_s).to eq('https://example.com?foo=bar')
    end

    it do
      h = described_class.new('https://example.com?foo=bar')
      expect(h.merge_query(foo: :baz).to_s).to eq('https://example.com?foo=baz')
    end

    it do
      h = described_class.new('https://example.com?foo=bar')
      expect(h.merge_query(asdf: :baz).to_s).to eq('https://example.com?asdf=baz&foo=bar')
    end
  end
end
