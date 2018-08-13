module SellerVersions
  class BaseForm < Reform::Form
    include Concerns::Contracts::Status
    include Forms::ValidationHelper

    def upload_for(key)
      self.model.public_send(key)
    end
  end
end
