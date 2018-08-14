module Sellers
  class CreateInvitationForm < Reform::Form
    include Forms::ValidationHelper

    property :email

    validation :default, inherit: true do
      required(:email).filled(:email?)
    end
  end
end
