class AuthTokensController < UIController
  before_action :redirect_if_logged_in, only: %i[dev_login show]

  def destroy
    warden.logout if current_user
    flash[:success] = t('.success')
    redirect_to root_path
  end

  def dev_login
    raise_404 unless Rails.env.development?

    warden.logout
    authenticate!(:developer)
    flash[:success] = t('.success')
    redirect_to root_path
  end

  def index
    render :index, layout: false
  end

  def show
    authenticate!
    flash[:success] = t('.success')
    redirect_to root_path
  end

  private

  def authenticate(auth_token)
    redirect_to root_path
  end

  def redirect_if_logged_in
    return if current_user.blank?

    flash[:info] = t('authorization.already_logged_in')
    redirect_to root_url
  end
end
