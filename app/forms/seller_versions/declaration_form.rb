module SellerVersions
  class DeclarationForm < BaseForm
    def representative_details_provided?
      [:representative_name, :representative_email, :representative_phone, :representative_position].map {|field|
        model.send(field)
      }.reject(&:present?).empty?
    end

    def business_details_provided?
      model.name.present? && model.abn.present?
    end

    property :agree

    validation :default do
      required(:agree).filled(:bool?, :true?)
    end
  end
end
