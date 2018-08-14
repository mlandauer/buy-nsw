module BuyerApplications
  class BasicDetailsForm < BaseForm
    property :name
    property :organisation

    validation :default do
      required(:name).filled
      required(:organisation).filled
    end
  end
end
