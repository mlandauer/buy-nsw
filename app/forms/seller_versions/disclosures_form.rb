module SellerVersions
  class DisclosuresForm < BaseForm
    property :receivership
    property :investigations
    property :legal_proceedings
    property :insurance_claims
    property :conflicts_of_interest
    property :other_circumstances

    property :receivership_details
    property :investigations_details
    property :legal_proceedings_details
    property :insurance_claims_details
    property :conflicts_of_interest_details
    property :other_circumstances_details

    validation :default do
      required(:receivership).filled(:bool?)
      required(:investigations).filled(:bool?)
      required(:legal_proceedings).filled(:bool?)
      required(:insurance_claims).filled(:bool?)
      required(:conflicts_of_interest).filled(:bool?)
      required(:other_circumstances).filled(:bool?)

      required(:receivership_details).maybe(:str?)
      required(:investigations_details).maybe(:str?)
      required(:legal_proceedings_details).maybe(:str?)
      required(:insurance_claims_details).maybe(:str?)
      required(:conflicts_of_interest_details).maybe(:str?)
      required(:other_circumstances_details).maybe(:str?)

      rule(receivership_details: [
        :receivership, :receivership_details,
      ]) do |checkbox, details|
        checkbox.true?.then(details.filled?)
      end

      rule(investigations_details: [
        :investigations, :investigations_details,
      ]) do |checkbox, details|
        checkbox.true?.then(details.filled?)
      end

      rule(legal_proceedings_details: [
        :legal_proceedings, :legal_proceedings_details,
      ]) do |checkbox, details|
        checkbox.true?.then(details.filled?)
      end

      rule(insurance_claims_details: [
        :insurance_claims, :insurance_claims_details,
      ]) do |checkbox, details|
        checkbox.true?.then(details.filled?)
      end

      rule(conflicts_of_interest_details: [
        :conflicts_of_interest, :conflicts_of_interest_details,
      ]) do |checkbox, details|
        checkbox.true?.then(details.filled?)
      end

      rule(other_circumstances_details: [
        :other_circumstances, :other_circumstances_details,
      ]) do |checkbox, details|
        checkbox.true?.then(details.filled?)
      end
    end
  end
end
