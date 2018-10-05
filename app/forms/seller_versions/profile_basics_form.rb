module SellerVersions
  class ProfileBasicsForm < BaseForm
    property :summary
    property :website_url
    property :linkedin_url

    validation :default, inherit: true do
      required(:summary).filled(max_word_count?: 50)
      required(:website_url).filled(:url?)
      optional(:linkedin_url).maybe(:str?, :url?)
    end
  end
end
