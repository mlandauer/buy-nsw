module Sellers::SellerVersion::Products::Contract
  class AvailabilitySupport < Base
    property :guaranteed_availability
    property :support_options
    property :support_options_additional_cost
    property :support_levels

    validation :default, inherit: true do
      required(:guaranteed_availability).filled(max_word_count?: 200)
      required(:support_options).filled(any_checked?: true, one_of?: Product.support_options.values)
      required(:support_options_additional_cost).filled
      required(:support_levels).filled(max_word_count?: 200)
    end
  end
end
