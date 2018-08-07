module Sellers::SellerVersion::Products::Contract
  class DataProtection < Base
    property :encryption_transit_user_types
    property :encryption_transit_user_other
    property :encryption_transit_network_types
    property :encryption_transit_network_other
    property :encryption_rest_types
    property :encryption_rest_other
    property :encryption_keys_controller

    validation :default, inherit: true do
      required(:encryption_transit_user_types).filled(any_checked?: true, one_of?: Product.encryption_transit_user_types.values)
      required(:encryption_transit_user_other).maybe(:str?)

      rule(encryption_transit_user_other: [:encryption_transit_user_types, :encryption_transit_user_other]) do |checkboxes, field|
        checkboxes.contains?('other').then(field.filled?)
      end

      required(:encryption_transit_network_types).filled(any_checked?: true, one_of?: Product.encryption_transit_network_types.values)
      required(:encryption_transit_network_other).maybe(:str?)

      rule(encryption_transit_network_other: [:encryption_transit_network_types, :encryption_transit_network_other]) do |checkboxes, field|
        checkboxes.contains?('other').then(field.filled?)
      end

      required(:encryption_rest_types).filled(any_checked?: true, one_of?: Product.encryption_rest_types.values)
      required(:encryption_rest_other).maybe(:str?)

      rule(encryption_rest_other: [:encryption_rest_types, :encryption_rest_other]) do |checkboxes, field|
        checkboxes.contains?('other').then(field.filled?)
      end

      required(:encryption_keys_controller).filled(in_list?: Product.encryption_keys_controller.values)
    end
  end
end
