module SellerVersions
  class BaseForm < Reform::Form
    include Concerns::FormStatus
    include Forms::ValidationHelper

    def upload_for(key)
      model.public_send(key)
    end
  end
end
