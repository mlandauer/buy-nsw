require 'rails_helper'

RSpec.describe Product do

  describe '#approved_seller_version' do
    it 'returns the approved seller version' do
      seller = create(:active_seller)
      create_list(:created_seller_version, 3, seller: seller)
      version = create(:approved_seller_version, seller: seller)
      product = create(:product, seller: seller)

      expect(product.approved_seller_version).to eq(version)
    end
  end

end
