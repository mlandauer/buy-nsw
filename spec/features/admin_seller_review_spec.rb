require 'rails_helper'

RSpec.describe 'Reviewing seller applications', type: :feature, js: true do

  describe 'as an admin user', user: :admin_user do
    it 'can approve an application' do
      application = create(:awaiting_assignment_seller_version)
      product = create(:inactive_product, :with_basic_details, seller: application.seller)

      visit '/ops'
      click_on 'Seller applications'
      click_on 'Reset filters'

      select_application_from_list(application.name)

      expect_application_state('awaiting_assignment')

      assign_application_to(@user.email)

      expect_flash_message('Application assigned')
      expect_application_state('ready_for_review')

      browse_application_details
      browse_product(product)

      decide_on_application(decision: 'Approve', response: 'Response text')
      expect_flash_message('Application approved')

      expect_application_state('approved')
    end

    it 'can filter applications by business identifiers' do
      application = create(:awaiting_assignment_seller_version)
      application.update_attribute(:start_up, false)

      visit '/ops'
      click_on 'Seller applications'
      click_on 'Reset filters'

      expect_listed(application)

      select 'Start Up', :from => 'Business Identifiers'
      click_on 'Apply filters'

      expect_unlisted(application)

      application.update_attribute(:start_up, true)
      refresh

      expect_listed(application)

    end

    it 'can filter to show the next version of reverted applications' do
      reverted_application = create(:ready_for_review_seller_version)
      reverted_application.return_to_applicant
      reverted_application.save!
      next_application = reverted_application.next_version
      created_application   = create(:created_seller_version)
      accepted_application  = create(:approved_seller_version)
      rejected_application  = create(:rejected_seller_version)
      submitted_application = create(:awaiting_assignment_seller_version)

      visit '/ops'
      click_on 'Seller applications'
      click_on 'Reset filters'

      expect_listed(
        next_application, created_application, accepted_application,
        rejected_application, submitted_application
      )
      # we expect reverted to never be listed again, as it has been archived.
      expect_unlisted(reverted_application)

      check 'Reverted'
      click_on 'Apply filters'

      expect_listed(next_application)
      expect_unlisted(
        created_application, accepted_application,
        rejected_application, submitted_application, reverted_application
      )

      uncheck 'Reverted'
      select 'Awaiting Assignment', :from => 'Status'
      click_on 'Apply filters'

      select_application_from_list(submitted_application.name)
      assign_application_to(@user.email)
      decide_on_application(decision: 'Return', response: 'You need to change some things.')

      visit '/ops/seller-applications'
      click_on 'Reset filters'
      check 'Reverted'
      click_on 'Apply filters'

      expect_listed(next_application, submitted_application.next_version)
      expect_unlisted(
        created_application, rejected_application,
        accepted_application, reverted_application,
        submitted_application,
      )
    end

    it 'can browse through different versions of an application' do
      submitted_application = create(:ready_for_review_seller_version)
      submitted_application.return_to_applicant
      submitted_application.save!
      next_application = submitted_application.next_version
      next_application.name += "version 2!"
      next_application.save!

      visit '/ops'
      click_on 'Seller applications'
      select 'Created', :from => 'Status'
      click_on 'Apply filters'

      expect_listed next_application

      select_application_from_list next_application.name

      expect_application_state 'created'
      expect_application_name next_application.name

      click_on 'Prev'

      expect_application_state 'archived'
      expect_application_name submitted_application.name

      click_on 'Next'

      expect_application_state 'created'
      expect_application_name next_application.name
    end

    it 'can see uploaded documents' do
      seller = create(:inactive_seller)

      fs = create(:clean_document)
      pic = create(:unscanned_document)
      wcc = create(:infected_document)

      application = create(
        :awaiting_assignment_seller_version,
        seller: seller,
        financial_statement_id: fs.id,
        professional_indemnity_certificate_id: pic.id,
        workers_compensation_certificate_id: wcc.id,
      )

      visit '/ops'
      click_on 'Seller applications'
      click_on 'Reset filters'

      select_application_from_list(application.name)

      click_navigation_item 'Documents'

      within_document admin_field_label(:financial_statement) do
        expect(page).to have_link('View document')
      end
      within_document admin_field_label(:professional_indemnity_certificate) do
        expect(page).to have_content('Awaiting virus scan')
      end
      within_document admin_field_label(:workers_compensation_certificate) do
        expect(page).to have_content('Infected')
      end
    end

    it 'tells the user when a seller is exempt from workers compensation insurance' do
      application = create(:awaiting_assignment_seller_version, workers_compensation_exempt: true)
      visit admin_seller_application_path(application)

      click_navigation_item 'Documents'

      within_document admin_field_label(:workers_compensation_certificate) do
        expect(page).to have_content('Not required')
      end
    end

    it 'tags sellers who were invited from the waitlist' do
      application = create(:awaiting_assignment_seller_version)
      create(:joined_waiting_seller, seller: application.seller)
      visit admin_seller_application_path(application)

      within '.current-view' do
        expect(page).to have_content('This seller was invited')
      end
    end

    context 'with uploaded terms for a product' do
      let!(:application) { create(:awaiting_assignment_seller_version) }
      let!(:product) { create(:inactive_product, :with_basic_details, seller: application.seller) }

      context 'for an unscanned document' do
        let!(:document) { create(:unscanned_document) }

        before(:example) {
          product.update_attribute(:terms_id, document.id)

          visit admin_seller_application_path(application)
          click_navigation_item(product.name)
        }

        it 'shows a holding message' do
          within_product_detail('Additional terms document') do
            expect(page).to have_content(document.original_filename)
            expect(page).to have_content('awaiting virus scan')
          end
        end
      end

      context 'for a clean document' do
        let!(:document) { create(:clean_document) }

        before(:example) {
          product.update_attribute(:terms_id, document.id)

          visit admin_seller_application_path(application)
          click_navigation_item(product.name)
        }

        it 'shows a download button' do
          within_product_detail('Additional terms document') do
            expect(page).to have_content(document.original_filename)
            expect(page).to have_link('View document')
          end
        end
      end

      context 'for an infected document' do
        let!(:document) { create(:infected_document) }

        before(:example) {
          product.update_attribute(:terms_id, document.id)

          visit admin_seller_application_path(application)
          click_navigation_item(product.name)
        }

        it 'shows an error message' do
          within_product_detail('Additional terms document') do
            expect(page).to have_content(document.original_filename)
            expect(page).to have_content('infected file')
          end
        end
      end
    end

    it 'shows seller recognition details' do
      application = create(:awaiting_assignment_seller_version)

      visit admin_seller_application_path(application)
      click_navigation_item 'Seller details'

      within_definition admin_field_label(:accreditations) do
        expect(page).to have_content(application.accreditations.first)
      end

      within_definition admin_field_label(:engagements) do
        expect(page).to have_content(application.engagements.first)
      end

      within_definition admin_field_label(:awards) do
        expect(page).to have_content(application.awards.first)
      end
    end
  end

  def select_application_from_list(seller_name)
    within '.record-list table' do
      row = page.find('td', text: seller_name).ancestor('tr')

      within row do
        click_on 'View'
      end
    end
  end

  def assign_application_to(email)
    page.find('h2', text: 'Assign this application').click
    select email, from: 'Assigned to'
    click_on 'Assign'
  end

  def expect_application_state(state)
    within '.status-indicator' do
      expect(page).to have_content(state)
    end
  end

  def expect_flash_message(message)
    within '.messages' do
      expect(page).to have_content(message)
    end
  end

  def expect_listed(*applications)
    within '.record-list table' do
      applications.each do |app|
        expect(page).to have_xpath(column_xpath(:ID), :text => app.id)
      end
    end
  end

  def expect_unlisted(*applications)
    if page.has_no_selector?('.record-list table')
      true
    else
      within '.record-list table' do
        applications.each do |app|
          expect(page).to have_no_xpath(column_xpath(:ID), :text => app.id)
        end
      end
    end
  end

  def expect_application_name(name)
    within '.view-admin-seller-applications-show aside h1' do
      expect(page).to have_content(name)
    end
  end

  def browse_application_details
    click_navigation_item 'Seller details'
    click_navigation_item 'Documents'
    click_navigation_item 'Application'
  end

  def browse_product(product)
    click_navigation_item product.name
    click_navigation_item 'Application'
  end

  def decide_on_application(decision:, response:)
    page.find('h2', text: 'Make a decision').click

    within_fieldset 'Outcome' do
      choose decision
    end

    fill_in 'Feedback', with: response

    click_on 'Make decision'
  end

  def within_document(heading_text, &block)
    within 'ul.documents' do
      header = page.find('header', text: heading_text)
      content = header.sibling('.document-details')

      within(content, &block)
    end
  end

  def admin_field_label(key)
    I18n.t("#{key}.name", scope: [ :admin, :seller_versions, :fields ])
  end

  def click_navigation_item(label)
    within '.right-col nav' do
      click_on label
    end
  end

  def within_product_detail(label, &block)
    within_definition(label, &block)
  end

  def within_definition(label, &block)
    term = page.find(:xpath, "//dt[contains(text(),'#{label}')]/following-sibling::dd[1]")
    within(term, &block)
  end

end
