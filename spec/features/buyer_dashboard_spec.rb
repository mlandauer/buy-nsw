require 'rails_helper'

RSpec.describe 'Buyer dashboard', type: :feature, user: :buyer_user do

  it 'shows a message to buyers awaiting review' do
    create(:ready_for_review_buyer_application, user: @user)

    visit '/'
    click_on 'Your buyer account'

    expect(page).to have_content('Your buyer account')
    expect(page).to have_content('Your buyer application is now being reviewed')
  end

  it 'shows a message to buyers with an active profile' do
    create(:approved_buyer_application, user: @user)

    visit '/'
    click_on 'Your buyer account'

    expect(page).to have_content('Your buyer account')
    expect(page).to have_content('Your buyer account is active')
  end


end
