class SellerAddressDecorator < BaseDecorator

  def country
    ISO3166::Country.translations[super]
  end

  def state
    SellerAddress.state.find_value(super).text
  end

end
