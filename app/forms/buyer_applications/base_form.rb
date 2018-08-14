module BuyerApplications
  class BaseForm < Reform::Form
    include Concerns::Contracts::Status
    include Forms::ValidationHelper

    def i18n_base
      'buyers.applications.steps'
    end
  end
end
