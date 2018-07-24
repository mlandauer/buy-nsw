class Sellers::ProfilesController < Sellers::BaseController
  before_action :require_seller_version!

  def show
  end

private
  def sellers
    @sellers ||= Seller.active
  end
  helper_method :sellers

  def seller_version
    @seller_version ||= sellers.find(params[:id]).approved_version
  end
  helper_method :seller_version

  def require_seller_version!
    raise NotFound unless seller_version.present?
  end

  def authorized_buyer
    current_user && current_user.buyer.present? && current_user.buyer.active?
  end
  helper_method :authorized_buyer
end
