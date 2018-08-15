FactoryBot.define do
  factory :product do
    association :seller

    after(:create) do |product, evaluator|
      unless evaluator.seller.versions.any?
        create(:approved_seller_version, seller: evaluator.seller)
      end
    end

    trait :inactive do
      state :inactive
    end

    trait :active do
      state :active
    end

    trait :with_basic_details do
      name 'Product name'
      summary 'Summary'
      section 'applications-software'
      audiences ['developers']

      reseller_type 'extra-support'
      custom_contact true

      association :terms, factory: :clean_document

      free_version true
      free_trial true
      pricing_currency 'other'
      pricing_currency_other 'GBP'

      pricing_min '123.00'
      pricing_max '321.00'

      education_pricing true
      not_for_profit_pricing true

      deployment_model ['other-cloud']
      addon_extension_type 'yes'
      api 'rest'
      government_network_type ['other']

      web_interface true
      installed_application true
      supported_os ['other']
      mobile_devices true
      accessibility_type 'exclusions'

      data_location 'other-known'
      own_data_centre true
      third_party_involved true

      data_import_formats ['other']
      data_export_formats ['other']
      data_access_restrictions true

      encryption_transit_user_types ['other']
      encryption_transit_network_types ['other']
      encryption_rest_types ['other']

      authentication_required true

      iso_27001 true
      iso_27017 true
      iso_27018 true
      csa_star true
      pci_dss true
      soc_2 true

      virtualisation true
      virtualisation_implementor 'third-party'
      virtualisation_technologies ['other']
    end

    factory :inactive_product, traits: [:inactive]
    factory :active_product, traits: [:active, :with_basic_details]
  end
end
