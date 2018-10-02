require 'rails_helper'

RSpec.describe Buyers::BuyerApplication::Create do
  let(:user) { create(:buyer_user) }

  it 'creates a buyer application' do
    result = Buyers::BuyerApplication::Create.call({}, 'current_user' => user)

    expect(result).to be_success

    expect(BuyerApplication.count).to eq(1)

    expect(result[:application_model]).to be_persisted
    expect(result[:application_model].user).to eq(user)
  end

  it 'does not create an additional application when one exists' do
    create(:buyer_application, user: user)
    Buyers::BuyerApplication::Create.call({}, 'current_user' => user)

    expect(BuyerApplication.count).to eq(1)
  end

  it 'sets the started_at timestamp for a new application' do
    time = 1.hour.ago

    Timecop.freeze(time) do
      result = Buyers::BuyerApplication::Create.call({}, 'current_user' => user)
      expect(result[:application_model].started_at.to_i).to eq(time.to_i)
    end
  end

  it 'logs an event when the application is started' do
    result = Buyers::BuyerApplication::Create.call({}, 'current_user' => user)

    expect(result[:application_model].events.last.message).to eq("Started application")
    expect(result[:application_model].events.last.user).to eq(user)
  end

  it 'does not update the started_at timestamp for an existing application' do
    application = create(:buyer_application, user: user, started_at: 1.hour.ago)

    result = Buyers::BuyerApplication::Create.call({}, 'current_user' => user)
    expect(result[:application_model].started_at.to_i).to eq(application.started_at.to_i)
  end
end
