module Sellers::SellerVersion::Contract
  class Contacts < Base
    property :contact_name
    property :contact_email
    property :contact_phone

    property :representative_name
    property :representative_email
    property :representative_phone
    property :representative_position

    validation :default, inherit: true do
      required(:seller_version).schema do
        required(:contact_name).filled(:str?)
        required(:contact_email).filled(:str?, :email?)
        required(:contact_phone).filled(:str?)

        required(:representative_name).filled(:str?)
        required(:representative_email).filled(:str?, :email?)
        required(:representative_phone).filled(:str?)
        required(:representative_position).filled(:str?)
      end
    end
  end
end
