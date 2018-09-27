module Products
  class BasicsForm < BaseForm
    include Concerns::NestedTextFieldArray

    def features=(array)
      super(filter_blank_array_values(array))
    end

    def benefits=(array)
      super(filter_blank_array_values(array))
    end

    def audiences=(array)
      super(filter_blank_array_values(array))
    end

    property :name
    property :summary
    property :audiences

    property :reseller_type
    property :organisation_resold

    property :custom_contact
    property :contact_name
    property :contact_email
    property :contact_phone

    collection :features, prepopulator: ->(_) { TextFieldArrayPrepopulator.call(self, name: :features, limit: 10) }
    collection :benefits, prepopulator: ->(_) { TextFieldArrayPrepopulator.call(self, name: :benefits, limit: 10) }

    validation :default, inherit: true do
      required(:name).filled
      required(:summary).filled(max_word_count?: 200)

      required(:audiences).filled(one_of?: Product.audiences.values, max_size?: 3)

      required(:reseller_type).filled
      required(:organisation_resold).maybe(:str?)

      rule(organisation_resold: [:reseller_type, :organisation_resold]) do |type, field|
        type.excluded_from?(['own-product']).then(field.filled?)
      end

      required(:custom_contact).filled(:bool?)
      optional(:contact_name).maybe(:str?)
      optional(:contact_email).maybe(:str?, :email?)
      optional(:contact_phone).maybe(:str?)

      rule(contact_name: [:custom_contact, :contact_name]) do |radio, name|
        radio.true?.then(name.filled?)
      end
      rule(contact_email: [:custom_contact, :contact_email]) do |radio, email|
        radio.true?.then(email.filled?)
      end

      required(:features).value(max_items?: 10)
      required(:benefits).value(max_items?: 10)
    end
  end
end
