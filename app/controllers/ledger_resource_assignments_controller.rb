# frozen_string_literal: true

class LedgerResourceAssignmentsController < DashboardBaseController
  before_action :set_ledger_resource
  before_action :ensure_searcher

  def create
    save_and_render_form(
      form: Forms::LedgerResources::Assign.new(
        ledger_resource_assign_params.merge(
          ledger_resource: @ledger_resource
        )
      ),
      on_failure: ->(_result) { redirect_to ledger_resource_assignments_path(@ledger_resource) },
      on_success: ->(_result) { redirect_to ledger_resource_path(@ledger_resource) }
    )
  end

  def index
    save_and_render_form(form: search_form) do |result|
      @result = result
      render :index
    end
  end

  def search
    save_and_render_form(form: search_form) do |result|
      @result = result
      respond_to do |format|
        format.html { redirect_to ledger_resource_assignments_path(@ledger_resource, q: params[:q]) }
        format.js
      end
    end
  end

  private

  def ensure_searcher
    return if @ledger_resource.searcher?

    flash[:info] = t('ledger_resources.search_not_available')
    redirect_to ledger_resource_path(@ledger_resource)
  end

  def ledger_resource_assign_params
    params
      .require(:forms_ledger_resources_assign)
      .permit(
        :resource_ledger_id
      )
  end

  def ledger_resource_search_params
    ret = params.permit(
      :q,
      pagination: {}
    )
    ret
  end

  helper_method :ledger_resource_search_params

  def search_form
    @search_form ||= Forms::LedgerResources::Search.new(
      ledger_resource_search_params.merge(
        ledger_resource: @ledger_resource
      )
    )
  end

  def set_ledger_resource
    @ledger_resource = current_organization.ledger_resources.find(params[:ledger_resource_id]).decorate
  end
end
