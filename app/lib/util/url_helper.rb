# frozen_string_literal: true

module Util
  class URLHelper
    attr_reader :url

    def initialize(val)
      @url = case val
             when String
               URI.parse(val)
             when URI::HTTP, URI::HTTPS
               val
             end
    end

    def merge_query(query_to_merge)
      use_url = url.dup
      use_url.query = Rack::Utils
                      .parse_nested_query(use_url.query)
                      .with_indifferent_access
                      .merge(query_to_merge)
                      .to_query
      use_url
    end
  end
end
