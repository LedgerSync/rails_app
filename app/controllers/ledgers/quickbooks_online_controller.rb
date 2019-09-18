# frozen_string_literal: true

module Ledgers
  class QuickBooksOnlineController < DashboardBaseController
    before_action :set_ledger, only: %i[destroy show update]

    def callback
      resp = oauth_client.auth_code.get_token(
        params[:code],
        redirect_uri: Settings.adaptors.quickbooks_online.oauth_redirect_uri
      )

      @ledger_form = Forms::Ledgers::QuickBooksOnline::Create.new(
        organization: current_organization,
        access_token: resp.token,
        code: params[:code],
        expires_at: Time.try(:at, resp.expires_at).try(:to_datetime),
        refresh_token: resp.refresh_token,
        response: resp,
        state: params[:state],
        realm_id: params[:realmId]
      )

      save_and_render_form(
        form: @ledger_form,
        on_failure: ->(_result) { redirect_to(new_ledgers_quickbooks_online_path) },
        on_success: ->(result) { redirect_or_to(ledgers_quickbooks_online_path(result.value), query: { ledger_id: result.value.id }) }
      )
    end

    def destroy
      OAuth2::AccessToken.new(
        oauth_client,
        @ledger.access_token,
        refresh_token: @ledger.refresh_token
      ).post(
        '/v2/oauth2/tokens/revoke',
        params: { token: @ledger.refresh_token }
      )

      @ledger.destroy!

      redirect_to ledgers_path
    end

    def new
      @grant_url = Util::QuickBooksOnline.grant_url
      store_redirect
      redirect_to @grant_url
    end

    def show
      @grant_url = Util::QuickBooksOnline.grant_url
    end

    def update
      @refresh_form = Forms::Ledgers::QuickBooksOnline::RefreshToken.new(
        ledger: @ledger
      )

      save_and_render_form(
        form: @refresh_form,
        on_failure: ->(_result) { redirect_to(ledgers_quickbooks_online_path(@ledger)) },
        on_success: ->(_result) { redirect_to(ledgers_quickbooks_online_path(@ledger)) }
      )
    end

    private

    def oauth_client
      @oauth_client ||= Util::QuickBooksOnline.oauth_client
    end

    def set_ledger
      @ledger = current_organization
                .ledgers(kind: Util::QuickBooksOnline::KEY)
                .object
                .find(params[:id])
                .decorate
    end
  end
end
