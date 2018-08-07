module Sellers::SellerVersion::Contract
  class Addresses < Base
    include Concerns::Contracts::Populators
    include Forms::ValidationHelper

    AddressPrepopulator = ->(_) {
      if self.addresses.size < 1
        self.addresses << SellerAddress.new(country: 'AU')
      end
    }

    def populate_addresses!(fragment:, collection:, **)
      # NOTE: Start by clearing the collection (if we haven't already done so)
      # so that the address field can always be populated from scratch.
      #
      # If we don't do this, Reform's collection weirdness means we have to
      # handle deltas.
      #
      unless @collection_cleared.present?
        collection.clear
        @collection_cleared = true
      end

      return skip! if fragment['_delete'] == '1'

      address = SellerAddress.new(
        fragment.slice('address', 'suburb', 'state', 'postcode', 'country')
      )

      collection.append(address)
    end

    collection :addresses, prepopulator: AddressPrepopulator, populator: :populate_addresses! do
      include Forms::ValidationHelper

      def i18n_base
        'sellers.applications.steps.addresses'
      end

      property :address
      property :suburb
      property :state
      property :postcode
      property :country

      # This pseudo-attribute is used in the form to support progressively-enhanced
      # nested record deletions
      #
      property :_delete, virtual: true

      validation :default, inherit: true do
        required(:address).filled
        required(:suburb).filled
        required(:state).filled
        required(:postcode).filled
        required(:country).filled(in_list?: ISO3166::Country.translations.keys)
      end
    end

    validation :default, inherit: true, with: { form: true } do
      required(:seller_version).schema do

        # NOTE: We have to duplicate the validations here otherwise calling
        # `valid?` on this form won't actually check if the addresses are valid.
        #
        # Likewise, if we remove the validations above, errors won't appear to
        # users on the form.
        #
        required(:addresses).filled(:array?, min_size?: 1) do
          each do
            schema do
              required(:address).filled
              required(:suburb).filled
              required(:state).filled
              required(:postcode).filled
              required(:country).filled(included_in?: ISO3166::Country.translations.keys)
            end
          end
        end

      end
    end

  end
end
