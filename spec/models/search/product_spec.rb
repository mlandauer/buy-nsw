require 'rails_helper'
require_relative '../concerns/search/seller_tag_filters'

RSpec.describe Search::Product do

  it_behaves_like 'Concerns::Search::SellerTagFilters', term: 'test', section: 'section'

  let(:section) { 'applications-software' }

  context 'pagination' do
    it 'returns results only for the specific page' do
      create_list(:active_product, 8, section: section)

      args = {
        term: nil,
        section: section,
        selected_filters: {},
        per_page: 5,
      }

      first_page = Search::Product.new(args.merge(page: 1))

      expect(first_page.results.size).to eq(8)
      expect(first_page.paginated_results.size).to eq(5)

      second_page = Search::Product.new(args.merge(page: 2))

      expect(second_page.results.size).to eq(8)
      expect(second_page.paginated_results.size).to eq(3)
    end
  end

  it 'filters by accessibility_type' do
    create_list(:active_product, 3, accessibility_type: 'none', section: section)
    accessible_product = create(:active_product, accessibility_type: 'all', section: section)

    search = described_class.new(
      section: section,
      selected_filters: {
        characteristics: [ :all_accessible ]
      }
    )

    expect(search.results).to contain_exactly(accessible_product)
  end

end
