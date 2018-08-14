module Admin
  class DecideBuyerApplicationForm < Reform::Form
    include Forms::ValidationHelper

    model :buyer_application

    property :decision, virtual: true
    property :decision_body

    validation :default, inherit: true do
      required(:decision).filled(in_list?: ['approve', 'reject', 'return_to_applicant'])
    end
  end
end
