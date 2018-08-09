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

  describe '.accessible' do
    it 'returns only products where "accessibility_type" is "all"' do
      create_list(:product, 3, accessibility_type: 'none')
      accessible_product = create(:product, accessibility_type: 'all')

      results = Product.accessible

      expect(results).to contain_exactly(accessible_product)
    end
  end

end
