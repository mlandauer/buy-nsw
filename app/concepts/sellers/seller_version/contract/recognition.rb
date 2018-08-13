module Sellers::SellerVersion::Contract
  class Recognition < Base
    include Concerns::Contracts::Populators

    def accreditations=(array)
      super(filter_blank_array_values(array))
    end

    def awards=(array)
      super(filter_blank_array_values(array))
    end

    def engagements=(array)
      super(filter_blank_array_values(array))
    end

    collection :accreditations, prepopulator: ->(_){ TextFieldArrayPrepopulator.(self, name: :accreditations, limit: 10) }
    collection :awards, prepopulator: ->(_){ TextFieldArrayPrepopulator.(self, name: :awards, limit: 10) }
    collection :engagements, prepopulator: ->(_){ TextFieldArrayPrepopulator.(self, name: :engagements, limit: 10) }

    validation :default, inherit: true do
      required(:accreditations).value(max_items?: 10)
      required(:awards).value(max_items?: 10)
      required(:engagements).value(max_items?: 10)
    end
  end
end
