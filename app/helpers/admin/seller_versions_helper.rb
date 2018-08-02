module Admin::SellerVersionsHelper
  include Sellers::ProfilesHelper

  include Admin::AssigneesHelper
  include Admin::DetailHelper

  include Admin::SellerVersions::DetailHelper

  def formatted_product_name(product)
    name = h(product.name || 'Unamed product')
    id = content_tag(:span, "##{h(product.id)}", class: 'product-id')

    ( "#{name} #{id}" ).html_safe
  end
end
