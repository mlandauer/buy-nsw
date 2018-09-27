module SellerVersions
  class ServicesForm < BaseForm
    property :offers_cloud, virtual: true
    property :services
    property :govdc

    def offers_cloud
      services.any? ? services.include?('cloud-services') : nil
    end

    def deserialize!(document)
      hash = super(document)

      if hash[:services]
        if hash[:offers_cloud] == 'true'
          hash[:services] << 'cloud-services'
        else
          services.delete('cloud-services')
        end

        if hash[:govdc] == 'true'
          hash[:services] << 'infrastructure'
        end
      end

      hash
    end

    validation :default, inherit: true, with: { form: true } do
      configure do
        option :form

        def offers_cloud?(list)
          list.include?('cloud-services')
        end

        def has_no_products?
          form.model.seller.products.empty?
        end
      end

      required(:services).maybe(one_of?: SellerVersion.services.values)
      required(:govdc).filled(:bool?)
      optional(:offers_cloud).maybe(:bool?)

      rule(services: [:offers_cloud, :services]) do |offers_cloud, services|
        offers_cloud.true?.then(services.filled?)
      end

      validate(no_cloud_products?: [:services, :offers_cloud]) do |services, offers_cloud|
        services.include?('cloud-services') || has_no_products?
      end

      rule(eligible_seller: [:services, :govdc]) do |services, govdc|
        services.offers_cloud? | govdc.true?
      end
    end
  end
end
