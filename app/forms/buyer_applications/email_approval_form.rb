module BuyerApplications
  class EmailApprovalForm < BaseForm
    property :application_body

    validation :default do
      required(:application_body).filled
    end
  end
end
