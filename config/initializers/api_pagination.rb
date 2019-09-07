# frozen_string_literal: true

ApiPagination.configure do |config|
  config.paginator = :kaminari

  config.page_header = "X-Page"
  config.total_header = "X-Total-Count"
  config.per_page_header = "X-Per-Page"

  config.page_param = :page
  config.per_page_param = :per_page
end