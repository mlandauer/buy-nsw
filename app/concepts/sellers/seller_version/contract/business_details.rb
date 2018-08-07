module Sellers::SellerVersion::Contract
  class BusinessDetails < Base
    property :name
    property :abn

    validation :default, with: {form: true} do
      configure do
        option :form

        def unique_abn?(value)
          SellerVersion.where.not(seller_id: form.model.seller_id).where(abn: value).empty?
        end

        def abn?(value)
          ABN.valid?(value)
        end
      end

      required(:name).filled
      required(:abn).filled

      rule(abn: [:abn]) do |abn|
        abn.filled? > abn.unique_abn?
      end
      rule(abn: [:abn]) do |abn|
        abn.filled? > abn.abn?
      end
    end
  end
end
