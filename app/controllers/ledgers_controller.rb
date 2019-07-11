class LedgersController < DashboardBaseController
  before_action :set_ledger, only: :show

  def show
    redirect_to @ledger.show_path
  end

  private

  def set_ledger
    @ledger = Ledger.find(params[:id]).decorate
  end
end