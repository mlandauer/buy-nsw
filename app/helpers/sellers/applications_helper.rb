module Sellers::ApplicationsHelper
  def other_service_options
    SellerVersion.services.options.reject {|(_, key)|
      key == 'cloud-services'
    }
  end

  def seller_application_root_breadcrumbs
    [
      [ 'Your application', sellers_application_path(application) ]
    ]
  end

  def seller_application_invitations_breadcrumbs
    seller_application_root_breadcrumbs + [
      [ 'Your team members', sellers_application_invitations_path(application) ]
    ]
  end

  def seller_application_products_list_breadcrumbs
    seller_application_root_breadcrumbs + [
      ['Your cloud products', sellers_application_products_path(application)],
    ]
  end

  def seller_application_product_breadcrumbs
    seller_application_products_list_breadcrumbs + [
      [ (product.name.present? ? product.name : 'Product'), sellers_application_product_path(application, product) ]
    ]
  end

end
