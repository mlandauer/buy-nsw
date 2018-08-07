module Buyers::BuyerApplication::Contract
  class EmploymentStatus < Base
    property :employment_status, on: :application

    validation :default, inherit: true do
      required(:application).schema do
        required(:employment_status, in_list?: BuyerApplication.employment_status.options).filled
      end
    end
  end
end
