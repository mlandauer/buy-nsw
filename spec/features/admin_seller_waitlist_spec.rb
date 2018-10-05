require 'rails_helper'

RSpec.describe 'Managing the seller waitlist', type: :feature, js: true do
  let(:csv_file) do
    Rails.root.join('spec', 'fixtures', 'files', 'waiting_seller_list.csv')
  end

  let(:csv) do
    CSV.read(csv_file, headers: true)
  end

  let(:record) { csv.first }

  let(:status_filter_label) do
    I18n.t(:name, scope: [
      :admin, :waiting_sellers, :search, :filters, :invitation_state,
    ])
  end

  describe 'as an admin user', user: :admin_user do
    it 'can filter the list' do
      create_list(:invited_waiting_seller, 3)
      seller = create(:waiting_seller)

      visit admin_waiting_sellers_path

      within 'div.filters' do
        select 'Created', from: status_filter_label
        click_button 'Apply filters'
      end

      expect(page.all('table tbody tr').size).to eq(1)

      within_table_row(seller.name) do
        expect(page).to have_selector('td', text: seller.contact_name)
      end
    end

    it 'can upload sellers to the waitlist' do
      visit admin_waiting_sellers_path
      upload_csv

      expect_uploaded_seller_preview
      click_button 'Complete upload'

      within '.messages' do
        expect(page).to have_content('Saved')
      end

      expect_uploaded_sellers_in_list
    end

    # I've disabled this spec as the feature appears to be disabled anyway - the checkboxes
    # are disabled and as a user you can't actually do this test. Notice the spec finds
    # a _non visible_ checkbox to click on.
    #
    # Also it's somewhat randomly failing and I can't find why. This feature is perhaps
    # incomplete but certainly not used by any operators as of today (18/09/18) -Brendan
    skip 'can send an invitation' do
      seller = create(:waiting_seller)
      visit admin_waiting_sellers_path

      within_table_row(seller.name) do
        page.find('input[type=checkbox]', visible: false).click
      end
      click_button 'Invite sellers'
      click_button 'Send invitations'

      within '.messages' do
        expect(page).to have_content('Invitations sent')
      end

      within_table_row(seller.name) do
        expect(page).to have_content('invited')
      end
    end
  end

  def upload_csv
    within '.upload-form' do
      page.find('h2', text: 'Upload sellers').click
      attach_file :file, csv_file
      click_button 'Save'
    end
  end

  def expect_uploaded_seller_preview
    within 'table tbody' do
      row = page.find('td', text: record['name']).ancestor('tr')

      within row do
        expect(page).to have_selector('td', text: record['address'])
        expect(page).to have_selector('td', text: record['suburb'])
        expect(page).to have_selector('td', text: record['postcode'])
      end
    end
  end

  def expect_uploaded_sellers_in_list
    within_table_row(record['name']) do
      expect(page).to have_selector('td', text: record['contact_name'])
      expect(page).to have_selector('td', text: 'created')
    end
  end

  def within_table_row(name, &block)
    within 'table tbody' do
      row = page.find('th', text: name).ancestor('tr')
      within(row, &block)
    end
  end
end
