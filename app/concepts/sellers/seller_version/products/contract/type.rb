module Sellers::SellerVersion::Products::Contract
  class Type < Base
    property :section

    validation :default, inherit: true do
      required(:section).filled(in_list?: Product.section.values)
    end
  end
end
