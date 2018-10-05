FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.org" }
    sequence(:password) { SecureRandom.hex(8) }
    confirmed_at { 1.day.ago }

    trait :buyer do
      roles ['buyer']
    end

    trait :inactive_buyer do
      roles ['buyer']

      after :create do |user|
        create(:created_buyer_application, user: user)
      end
    end

    trait :active_buyer do
      roles ['buyer']

      after :create do |user|
        create(:approved_buyer_application, user: user)
      end
    end

    trait :seller do
      roles ['seller']
    end

    trait :with_seller do
      after :create do |user, evaluator|
        seller = evaluator.seller || create(:seller, owner: user)
        user.update_attribute(:seller_id, seller.id)
      end
    end

    trait :admin do
      roles ['admin']
    end

    factory :buyer_user, traits: [:buyer]
    factory :inactive_buyer_user, traits: [:inactive_buyer]
    factory :active_buyer_user, traits: [:active_buyer]

    factory :seller_user, traits: [:seller]
    factory :seller_user_with_seller, traits: [:seller, :with_seller]
    factory :admin_user, traits: [:admin]
  end
end
