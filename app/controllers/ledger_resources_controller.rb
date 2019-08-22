# frozen_string_literal: true

class LedgerResourcesController < DashboardBaseController
  before_action :set_ledger_resource

  def create
    @ledger_resource_form = Forms::LedgerResources::ApproveCreation.new(
      approved_by: current_user,
      ledger_resource: @ledger_resource
    )

    save_and_render_form(
      form: @ledger_resource_form,
      on_failure: ->(_result) { render :show },
      on_success: ->(_result) { redirect_to(ledger_resource_path(@ledger_resource)) }
    )
  end

  private

  def set_ledger_resource
    @ledger_resource = current_organization.ledger_resources.find(params[:id]).decorate
  end
end
