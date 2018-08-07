module Sellers::SellerVersion::Contract
  class Characteristics < Base
    property :number_of_employees
    property :corporate_structure

    property :start_up
    property :sme
    property :not_for_profit

    property :regional

    property :australian_owned
    property :disability
    property :female_owned
    property :indigenous

    property :no_experience
    property :local_government_experience
    property :state_government_experience
    property :federal_government_experience
    property :international_government_experience

    validation :default do
      # TODO: These don't currently return a nice human-friendly
      # error message currently
      required(:number_of_employees).
        value(included_in?: SellerVersion.number_of_employees.values)
      required(:corporate_structure).
        value(included_in?: SellerVersion.corporate_structure.values)
      required(:regional).filled(:bool?)
    end
  end
end
