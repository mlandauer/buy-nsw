module Buyers::BuyerApplication::Contract
  class BasicDetails < Base
    property :name, on: :application
    property :organisation, on: :application

    validation :default do
      required(:application).schema do
        required(:name).filled
        required(:organisation).filled
      end
    end
  end
end
