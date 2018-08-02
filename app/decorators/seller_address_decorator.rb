class SellerAddressDecorator < BaseDecorator

  def country
    ISO3166::Country.translations[super]
  end

  def state
    state_text
  end

end
