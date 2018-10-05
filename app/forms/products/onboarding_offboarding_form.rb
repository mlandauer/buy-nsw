module Products
  class OnboardingOffboardingForm < BaseForm
    property :onboarding_assistance
    property :offboarding_assistance
    property :demo_video_url

    validation :default, inherit: true do
      required(:onboarding_assistance).filled(max_word_count?: 200)
      required(:offboarding_assistance).filled(max_word_count?: 200)
      required(:demo_video_url).maybe(:str?, :url?)
    end
  end
end
