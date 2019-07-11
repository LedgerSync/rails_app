class SyncsController < DashboardBaseController
  before_action :set_sync, only: %i[perform show]

  def perform
    SyncJobs::Perform.perform_async(@sync.id)

    flash[:notice] = t('syncs.processing_in_background')
    redirect_to sync_path(@sync)
  end

  private

  def set_sync
    @sync = current_account.syncs.find(params[:id]).decorate
  end
end
