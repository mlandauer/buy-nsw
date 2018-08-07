FactoryBot.define do
  factory :buyer_application do
    association :buyer
    association :user

    state 'created'

    trait :completed do
      name 'Sarah'
      organisation 'Organisation Name'
      application_body 'Text'
      employment_status 'employee'
    end

    trait :contractor do
      employment_status 'contractor'
    end

    trait :manager_approval do
      contractor

      manager_name 'Manager Manager'
      manager_email 'manager@example.org'
    end

    trait :with_manager_approval_token do
      sequence(:manager_approval_token) {|n| n }
    end

    trait :created do
      state 'created'
    end

    trait :awaiting_manager_approval do
      completed
      manager_approval
      with_manager_approval_token

      state 'awaiting_manager_approval'
    end

    trait :awaiting_assignment do
      completed

      state 'awaiting_assignment'
    end
    
    trait :ready_for_review do
      completed

      state 'ready_for_review'
    end

    trait :approved do
      completed

      state 'approved'
      decision_body 'Welcome'
    end

    trait :rejected do
      completed

      state 'rejected'
      decision_body 'Sorry, no.'
    end

    factory :created_buyer_application, traits: [:created]
    factory :created_manager_approval_buyer_application, traits: [:created, :manager_approval]
    factory :completed_buyer_application, traits: [:created, :completed]
    factory :completed_manager_approval_buyer_application, traits: [:created, :completed, :manager_approval]
    factory :awaiting_manager_approval_buyer_application, traits: [:awaiting_manager_approval]
    factory :awaiting_assignment_buyer_application, traits: [:awaiting_assignment]
    factory :ready_for_review_buyer_application, traits: [:ready_for_review]
    factory :approved_buyer_application, traits: [:approved]
    factory :rejected_buyer_application, traits: [:rejected]
  end
end
