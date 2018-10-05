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
    @seller_version ||= SellerVersionDecorator.new(
      sellers.find(params[:id]).approved_version,
      view_context,
    )
  end
  helper_method :seller_version

  def require_seller_version!
    raise NotFound if seller_version.blank?
  end

  def authorized_buyer
    current_user && current_user.is_active_buyer?
  end
  helper_method :authorized_buyer
end
