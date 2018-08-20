module BuyerApplications
  class EmailApprovalForm < BaseForm
    property :application_body
    property :cloud_purchase
    property :contactable

    validation :default do
      required(:application_body).filled
    end
  end
end
