class SyncLedgersController < DashboardBaseController
  before_action :set_sync, only: :create
  before_action :set_ledger, only: :create

  def create
    @sync_ledger_form = Forms::SyncLedgers::Upsert.new(
      sync: @sync,
      ledger: @ledger
    )

    save_and_render_form(
      form: @sync_ledger_form,
      on_failure: ->(_result) { redirect_to sync_path(@sync) },
      on_success: ->(_result) { redirect_to sync_path(@sync) }
    )
  end

  private

  def set_ledger
    @ledger = current_organization.ledgers.object.find(params[:ledger]).decorate
  end

  def set_sync
    @sync = current_organization.syncs.find(params[:sync_id]).decorate
  end
end
