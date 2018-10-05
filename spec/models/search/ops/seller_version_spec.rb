require 'rails_helper'

RSpec.describe Search::Admin::SellerVersion do
  describe '#available_filters' do
    it 'returns all admin users in the assigned_to filter' do
      user = create(:admin_user)
      search = described_class.new(
        selected_filters: {}
      )

      expect(search.available_filters[:assigned_to]).to eq(
        [
          [user.email, user.id],
        ]
      )
    end
  end

  it 'returns all seller versions by default' do
    create_list(:seller_version, 10)

    search = described_class.new(
      selected_filters: {}
    )

    expect(search.results.size).to eq(10)
  end

  it 'filters by assignee' do
    user = create(:admin_user)

    create_list(:seller_version, 5)
    create_list(:seller_version, 3, assigned_to: user)

    search = described_class.new(
      selected_filters: {
        assigned_to: user.id,
      }
    )

    expect(search.results.size).to eq(3)
  end

  it 'filters by state' do
    create_list(:seller_version, 5, state: 'created')
    create_list(:seller_version, 3, state: 'ready_for_review')

    search = described_class.new(
      selected_filters: {
        state: 'created',
      }
    )

    expect(search.results.size).to eq(5)
  end

  it 'filters by name' do
    create_list(:seller_version, 5, name: 'Foo')
    create_list(:seller_version, 3, name: 'Bar')

    search = described_class.new(
      selected_filters: {
        name: 'Bar',
      }
    )

    expect(search.results.size).to eq(3)
  end
end
