require 'rails_helper'

RSpec.describe 'Ordering products', type: :feature, js: true, user: :active_buyer_user do
  let(:product) { create(:active_product) }

  it 'can create an order' do
    visit pathway_product_path(product.section, product)
    click_on 'Buy this product'

    fill_in label(:estimated_contract_value), with: '100000'

    within_fieldset label(:contacted_seller) do
      choose 'Yes'
    end

    within_fieldset label(:purchased_cloud_before) do
      choose 'Yes'
    end

    click_on 'Next'

    expect(page).to have_content('We will be in touch')
  end

  def label(key)
    I18n.t(:label, scope: [ :buyers, :product_orders, key ])
  end
end
