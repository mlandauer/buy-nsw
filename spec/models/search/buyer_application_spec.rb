require 'rails_helper'

RSpec.describe Search::BuyerApplication do
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

  it 'returns all buyer applications by default' do
    create_list(:buyer_application, 10)

    search = described_class.new(
      selected_filters: {}
    )

    expect(search.results.size).to eq(10)
  end

  it 'filters by assignee' do
    user = create(:admin_user)

    create_list(:buyer_application, 5)
    create_list(:buyer_application, 3, assigned_to: user)

    search = described_class.new(
      selected_filters: {
        assigned_to: user.id,
      }
    )

    expect(search.results.size).to eq(3)
  end

  it 'filters by state' do
    create_list(:buyer_application, 5, state: 'created')
    create_list(:buyer_application, 3, state: 'ready_for_review')

    search = described_class.new(
      selected_filters: {
        state: 'created',
      }
    )

    expect(search.results.size).to eq(5)
  end

  it 'filters by name' do
    names = ['Michael', 'Thomas', 'Roland']
    names.each do |name|
      create(:buyer_application, name: name)
    end

    search = described_class.new(selected_filters: { name: names.first })

    expect(search.results.map(&:name)).to contain_exactly(names.first)
  end

  it 'filters by email' do
    emails = ['foo@example.org', 'bar@example.org', 'baz@example.org']
    emails.each do |email|
      create(:buyer_application,
             user: create(:user, email: email),)
    end

    search = described_class.new(selected_filters: { email: emails.first })

    expect(search.results.map(&:user).map(&:email)).to contain_exactly(emails.first)
  end
end
