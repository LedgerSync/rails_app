# frozen_string_literal: true

module Dev
  class SyncsController < BaseController
    before_action :ensure_authorized_user

    def create
      sync = Forms::Syncs::Create.new(create_params).save.raise_if_error.value

      redirect_to sync_path(sync)
    end

    private

    def create_params
      @create_params ||= JSON.parse(params[:request_body])
    end

    def create_by_api
      conn = Faraday.new
      conn.basic_auth(Settings.api.root_secret_key, '')
      response = conn.post(api_v1_syncs_url, create_params)

      if response.status == 200
        flash[:success] = response.body
      else
        flash[:danger] = response.body
      end
    end
  end
end
