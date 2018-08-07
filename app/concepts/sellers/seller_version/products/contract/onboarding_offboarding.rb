module Sellers::SellerVersion::Products::Contract
  class OnboardingOffboarding < Base
    property :onboarding_assistance
    property :offboarding_assistance

    validation :default, inherit: true do
      required(:onboarding_assistance).filled(max_word_count?: 200)
      required(:offboarding_assistance).filled(max_word_count?: 200)
    end
  end
end
