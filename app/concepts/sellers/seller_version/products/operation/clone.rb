# rubocop:disable Airbnb/ClassOrModuleDeclaredInWrongFile
class Sellers::SellerVersion::Products::Clone < Trailblazer::Operation
  step :model!
  step :build_new_product!
  step :copy_attributes!
  step :set_new_product_name!
  step :persist_new_product!

  def model!(options, params:, **)
    return false if options['config.current_user'].blank?

    options[:application_model] = options['config.current_user'].
      seller_versions.find(params[:application_id])
    options[:seller_model] = options[:application_model].seller
    options[:product_model] = options[:seller_model].products.find(params[:id])
  end

  def build_new_product!(options, **)
    options[:new_product_model] = options[:seller_model].products.build
  end

  def copy_attributes!(options, **)
    attributes = options[:product_model].attributes.except(*excluded_attributes)
    options[:new_product_model].attributes = attributes
  end

  def set_new_product_name!(options, **)
    options[:new_product_model].name = "#{options[:product_model].name} copy"
  end

  def persist_new_product!(options, **)
    options[:new_product_model].save
  end

  def excluded_attributes
    ['id', 'created_at', 'updated_at', 'state']
  end
end
# rubocop:enable Airbnb/ClassOrModuleDeclaredInWrongFile
