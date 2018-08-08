module Buyers::BuyerApplication::Contract
  class BasicDetails < Base
    property :name
    property :organisation

    validation :default do
      required(:name).filled
      required(:organisation).filled
    end
  end
end
