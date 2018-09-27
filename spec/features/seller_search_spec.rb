require 'rails_helper'

RSpec.describe 'Searching sellers', type: :feature, js: true do
  let!(:seller_1) do
    create(:approved_seller_version,
           name: 'Construction Ltd',
           summary: 'Buildings',
           start_up: false,
           regional: false,
           services: ['cloud-services'])
  end
  let!(:seller_2) do
    create(:approved_seller_version,
           name: 'Cloud Ltd',
           summary: 'Digital',
           start_up: true,
           regional: false,
           services: [])
  end

  it 'returns a result for a given term' do
    visit sellers_search_path

    fill_in 'Keyword', with: 'Construction'
    click_on 'Search'

    within '.results' do
      expect(page.all('li').size).to eq(1)
      expect(page).to have_content(:li, seller_1.name)
    end
  end

  it 'can filter by a tag' do
    visit sellers_search_path

    fill_in 'Keyword', with: 'Ltd'
    click_on 'Search'

    expect(page.all('.results li.result').size).to eq(2)

    within '.filters' do
      check 'Start-up'
    end
    click_on 'Update results'

    expect(page.all('.results li.result').size).to eq(1)

    within '.results' do
      expect(page).to have_content(:li, seller_2.name)
    end
  end

  it 'can filter by a service' do
    visit sellers_search_path

    fill_in 'Keyword', with: 'Ltd'
    click_on 'Search'

    expect(page.all('.results li.result').size).to eq(2)

    within '.filters' do
      check 'Cloud products'
    end
    click_on 'Update results'

    expect(page.all('.results li.result').size).to eq(1)

    within '.results' do
      expect(page).to have_content(:li, seller_1.name)
    end
  end
end
