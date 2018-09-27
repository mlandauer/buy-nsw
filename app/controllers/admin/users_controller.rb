class Admin::UsersController < Admin::BaseController
  before_action :authenticate_admin!
  skip_before_action :authenticate_admin!, only: [:stop_impersonating]

  def index
  end

  def impersonate
    user = User.without_role("admin").find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to admin_users_path
  end

  def search
    @search ||= Search::Admin::User.new(
      selected_filters: params,
      default_values: {
      },
      page: params.fetch(:page, 1),
      per_page: 50,
    )
  end
  helper_method :search
end
