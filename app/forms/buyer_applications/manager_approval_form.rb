module BuyerApplications
  class ManagerApprovalForm < BaseForm
    property :manager_name
    property :manager_email

    validation :default do
      required(:manager_name).filled
      required(:manager_email).filled
    end
  end
end
