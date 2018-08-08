module Buyers::BuyerApplication::Contract
  class EmailApproval < Base
    property :application_body

    validation :default do
      required(:application_body).filled
    end
  end
end
