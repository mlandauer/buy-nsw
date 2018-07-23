class SellerDecorator < BaseDecorator

  def agreed_by_email
    if first_version.present?
      first_version.agreed_by.email if first_version.agreed_by.present?
    end
  end

  def addresses
    super.map {|address|
      SellerAddressDecorator.new(address, view_context)
    }
  end

end
