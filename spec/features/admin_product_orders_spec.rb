require 'rails_helper'

RSpec.describe 'Reviewing product orders', type: :feature, js: true do
  describe 'as an admin user', user: :admin_user do
    it 'can view the order list' do
      orders = create_list(:product_order, 3)

      visit '/ops'
      click_on 'Product Orders'

      expect(page).to have_content('3 product orders')

      within '.record-list' do
        expect(page).to have_content(orders.first.buyer.name)
      end
    end
  end
end
