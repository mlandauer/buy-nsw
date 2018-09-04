require 'rails_helper'

RSpec.describe 'Logging in as a user via pretend', type: :feature, js: true do

  let(:resolved_message) { I18n.t('admin.problem_reports.messages.resolved') }
  let(:updated_message) { I18n.t('admin.problem_reports.messages.updated') }

  let!(:seller) { create(:created_seller_version) }

  describe 'as an admin user', user: :admin_user do
    it 'can log into another user' do
      visit '/ops'
      click_on 'Users'

      select_user_from_list(seller.owners.first)
      expect_pretender_alert(seller.owners.first)
      expect_user_email(seller.owners.first)

      select_continue_application
      expect_pretender_alert(seller.owners.first)
      expect_user_email(seller.owners.first)
      expect_seller_application

      select_back_to_admin
      expect_no_pretender_alert
    end
  end

  def select_user_from_list(user)
    within '.record-list table' do
      row = page.find('td', text: user.email).ancestor('tr')

      within row do
        click_on 'Sign in as'
      end
    end
  end

  def expect_pretender_alert(user)
    within '.pretender-alert' do
      expect(page).to have_content('signed in as ' + user.email)
    end
  end

  def expect_user_email(user)
    within 'aside.user' do
      expect(page).to have_content(user.email)
    end
  end

  def select_continue_application
    within 'aside.user' do
      click_on 'Continue application'
    end
  end

  def expect_seller_application
    within 'main#content' do
      expect(page).to have_content('Your seller application')
    end
  end

  def select_back_to_admin
    within '.pretender-alert' do
      click_on 'Back to admin'
    end
  end

  def expect_no_pretender_alert
    expect(page).not_to have_selector('.pretender-alert')
  end
end
