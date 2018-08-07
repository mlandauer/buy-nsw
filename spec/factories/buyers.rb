FactoryBot.define do
  factory :buyer do
    association :user

    trait :inactive do
      state :inactive
    end

    trait :active do
      state :active
    end

    factory :active_buyer, traits: [:active]
    factory :inactive_buyer, traits: [:inactive]
  end
end
