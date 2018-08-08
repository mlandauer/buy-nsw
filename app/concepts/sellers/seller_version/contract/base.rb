module Sellers::SellerVersion::Contract
  class Base < Reform::Form
    include Concerns::Contracts::MultiStepForm
    include Concerns::Contracts::Status
    include Forms::ValidationHelper

    def upload_for(key)
      self.model.public_send(key)
    end

    def i18n_base
      'sellers.applications.steps'
    end
  end
end
