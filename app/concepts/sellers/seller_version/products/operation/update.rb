# rubocop:disable Airbnb/ClassOrModuleDeclaredInWrongFile
class Sellers::SellerVersion::Products::Update < Trailblazer::Operation
  class Present < Sellers::SellerVersion::Update::Present
    def model!(options, params:, **)
      options['model.seller'] = options['config.current_user'].seller
      options['model.application'] ||= options['model.seller'].versions.created.
        find(params[:application_id])
      options['model.product'] = options['model.seller'].products.find(params[:id])

      options['model.product'].present?
    end

    def contract!(options, **)
      options['contract.default'] = options['config.contract_class'].new(options['model.product'])
    end
  end

  step Nested(Present)

  # NOTE: We use the Validate method here to assign values, but we don't care
  # if they are invalid as we want the user to be able to return later to edit
  # the form.
  #
  success :validate_form!
  step Contract::Persist()

  success :expire_progress_cache!

  # NOTE: Invoking this again at the end of the flow means that we can add
  # validation errors and show the form again when the fields are invalid.
  #
  step :prepopulate!
  step :return_valid_state!

  def validate_form!(options, params:, **)
    options['result.valid'] = options['contract.default'].validate(params[:seller_application])
  end

  def expire_progress_cache!(options, **)
    cache_key = "sellers.products.#{options['model.product'].id}.*"
    Rails.cache.delete_matched(cache_key)
  end

  def prepopulate!(options, **)
    contract = options['contract.default']
    contract.prepopulate!
  end

  def return_valid_state!(options, **)
    options['result.valid']
  end
end
# rubocop:enable Airbnb/ClassOrModuleDeclaredInWrongFile
