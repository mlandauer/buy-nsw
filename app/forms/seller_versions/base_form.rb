module SellerVersions
  class BaseForm < Reform::Form
    include Concerns::FormStatus
    include Forms::ValidationHelper

    def upload_for(key)
      self.model.public_send(key)
    end
  end
end
