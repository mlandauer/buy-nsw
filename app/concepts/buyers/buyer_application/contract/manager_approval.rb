module Buyers::BuyerApplication::Contract
  class ManagerApproval < Base
    property :manager_name
    property :manager_email

    validation :default do
      required(:manager_name).filled
      required(:manager_email).filled
    end
  end
end
