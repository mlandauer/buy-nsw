module Products
  class SecurityPracticesForm < BaseForm
    property :secure_development_approach
    property :penetration_testing_frequency
    property :penetration_testing_approach

    validation :default, inherit: true do
      required(:secure_development_approach).filled(in_list?: Product.secure_development_approach.values)
      required(:penetration_testing_frequency).filled(in_list?: Product.penetration_testing_frequency.values)
      required(:penetration_testing_approach).filled(one_of?: Product.penetration_testing_approach.values)
    end
  end
end
