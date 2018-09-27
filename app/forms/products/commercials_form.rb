module Products
  class CommercialsForm < BaseForm
    property :free_version
    property :free_version_details

    property :free_trial
    property :free_trial_url

    property :pricing_currency
    property :pricing_currency_other
    property :pricing_min
    property :pricing_max
    property :pricing_unit
    property :pricing_variables
    property :pricing_calculator_url

    property :education_pricing
    property :education_pricing_eligibility
    property :education_pricing_differences

    property :not_for_profit_pricing
    property :not_for_profit_pricing_eligibility
    property :not_for_profit_pricing_differences

    validation :default, inherit: true do
      configure do
        def currency?(value)
          Money::Currency.new(value)
        rescue Money::Currency::UnknownCurrency
          false
        end
      end

      required(:free_version).filled(:bool?)
      required(:free_version_details).maybe(max_word_count?: 50)

      rule(free_version_details: [:free_version, :free_version_details]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:free_trial).filled(:bool?)
      required(:free_trial_url).maybe(:str?, :url?)

      rule(free_trial_url: [:free_trial, :free_trial_url]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:pricing_currency).filled
      required(:pricing_currency_other).maybe(:str?, :currency?)

      rule(pricing_currency_other: [:pricing_currency, :pricing_currency_other]) do |type, field|
        type.eql?('other').then(field.filled?)
      end

      required(:pricing_min).filled(:number?)
      required(:pricing_max).filled(:number?)
      required(:pricing_unit).filled(:str?)

      required(:pricing_variables).filled(:str?)
      required(:pricing_calculator_url).maybe(:str?, :url?)

      required(:education_pricing).filled(:bool?)
      required(:education_pricing_eligibility).maybe(:str?)
      required(:education_pricing_differences).maybe(:str?)

      rule(education_pricing_eligibility: [:education_pricing, :education_pricing_eligibility]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(education_pricing_differences: [:education_pricing, :education_pricing_differences]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:not_for_profit_pricing).filled(:bool?)
      required(:not_for_profit_pricing_eligibility).maybe(:str?)
      required(:not_for_profit_pricing_differences).maybe(:str?)

      rule(not_for_profit_pricing_eligibility: [:not_for_profit_pricing, :not_for_profit_pricing_eligibility]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(not_for_profit_pricing_differences: [:not_for_profit_pricing, :not_for_profit_pricing_differences]) do |radio, field|
        radio.true?.then(field.filled?)
      end
    end
  end
end
