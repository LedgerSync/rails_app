# frozen_string_literal: true

module Ledgers
  class TestController < DashboardBaseController
    before_action :ensure_test_env
    before_action :set_ledger, only: %i[show]

    private

    def ensure_test_env
      return if Rails.env.test?

      raise_404
    end

    def set_ledger
      @ledger = current_organization
                .ledgers(kind: LedgerSync.adaptors.test.root_key.to_s)
                .object
                .find(params[:id])
                .decorate
    end
  end
end
