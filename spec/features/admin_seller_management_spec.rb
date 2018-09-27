require 'rails_helper'

RSpec.describe 'Managing sellers', type: :feature, js: true do
  describe 'as an admin user', user: :admin_user do
    it 'can revert a seller' do
      seller = create(:approved_seller_version, assigned_to: @user)

      visit admin_seller_applications_path
      click_on 'Reset filters'

      select_seller_from_list(seller.name)
      expect_seller_state('approved')
      deactivate_seller

      expect_flash_message(
        I18n.t('admin.seller_versions.messages.revert_success')
      )
      expect_seller_state('created')
    end
  end

  def select_seller_from_list(seller_name)
    within '.record-list table' do
      row = page.find('td', text: seller_name).ancestor('tr')

      within row do
        click_on 'View'
      end
    end
  end

  def deactivate_seller
    page.find('h2', text: 'Revert this application').click
    click_on 'Deactivate'
  end

  def expect_seller_state(state)
    within '.status-indicator' do
      expect(page).to have_content(state)
    end
  end

  def expect_flash_message(message)
    within '.messages' do
      expect(page).to have_content(message)
    end
  end
end
