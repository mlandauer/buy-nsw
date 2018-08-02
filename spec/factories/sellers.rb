FactoryBot.define do
  factory :seller do

    # NOTE: The following blocks maintain support for passing an owner into the
    # factory (as per the previous behaviour)
    #
    transient do
      owner nil
    end

    after(:create) do |seller, evaluator|
      if evaluator.owner && evaluator.owner.seller_id != seller.id
        evaluator.owner.update_attribute(:seller_id, seller.id)
      else
        create(:seller_user, seller: seller)
      end
    end

    trait :inactive do
      state :inactive
    end

    trait :active do
      state :active
    end

    factory :active_seller, traits: [:active]
    factory :inactive_seller, traits: [:inactive]
  end
end
