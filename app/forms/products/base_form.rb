module Products
  class BaseForm < Reform::Form
    include Concerns::FormStatus
    include Forms::ValidationHelper

    def product_id
      model.id
    end

    def upload_for(key)
      model.public_send(key)
    end
  end
end
