# frozen_string_literal: true

module SearchHelpers
  def lib_customers
    2.times.map do |i|
      LedgerSync::Customer.new(
        email: "test#{i}@example.com",
        ledger_id: "ledger-id-#{i}",
        name: "Customer #{i}"
      )
    end
  end
end
