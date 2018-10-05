class Sellers::SearchController < Sellers::BaseController
  helper Sellers::ProfilesHelper

  private

  def search
    @search ||= Search::SellerVersion.new(
      selected_filters: params,
      page: params.fetch(:page, 1),
      per_page: 25,
    )
  end
  helper_method :search
end
