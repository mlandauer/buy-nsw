class Sellers::Applications::BaseController < Sellers::BaseController
  before_action :authenticate_user!
  layout '../sellers/applications/shared/_layout'

private

  def _run_options(options)
    options.merge( "current_user" => current_user )
  end

  def application
    @application ||= current_user.seller_applications.created.find(params[:id])
  end
  helper_method :application
end
