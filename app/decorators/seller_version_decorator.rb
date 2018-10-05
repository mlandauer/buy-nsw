class SellerVersionDecorator < BaseDecorator
  def agreed_by_email
    agreed_by.email if agreed_by.present?
  end

  def addresses
    super.map do |address|
      SellerAddressDecorator.new(address, view_context)
    end
  end
end
