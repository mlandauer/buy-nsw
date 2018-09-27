require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Create do
  let(:user) { create(:seller_user) }

  def perform_operation
    described_class.call({}, 'config.current_user' => user)
  end

  it 'creates a seller and seller version' do
    result = perform_operation

    expect(result).to be_success

    expect(Seller.count).to eq(1)
    expect(SellerVersion.count).to eq(1)

    expect(result['model.seller_version']).to be_persisted
    expect(result['model.seller']).to be_persisted

    expect(result['model.seller'].owners).to contain_exactly(user)
    expect(user.seller).to eq(result['model.seller'])
  end

  it 'does not create an additional seller when one exists' do
    seller = create(:seller, owner: user)
    result = perform_operation

    expect(Seller.count).to eq(1)
    expect(SellerVersion.count).to eq(1)
  end

  it 'does not create an additional version when one exists' do
    seller = create(:seller, owner: user)
    application = create(:seller_version, seller: seller)

    result = perform_operation

    expect(Seller.count).to eq(1)
    expect(SellerVersion.count).to eq(1)
  end

  it 'sets the started_at timestamp for a new version' do
    time = 1.hour.ago

    Timecop.freeze(time) do
      result = perform_operation
      expect(result['model.seller_version'].started_at.to_i).to eq(time.to_i)
    end
  end

  it 'logs an event when the version is started' do
    result = perform_operation
    expect(result['model.seller_version'].events.last.message).to eq("Started application")
    expect(result['model.seller_version'].events.last.user).to eq(user)
  end

  it 'does not update the started_at timestamp for an existing version' do
    seller = create(:seller, owner: user)
    application = create(:seller_version, seller: seller, started_at: 1.hour.ago)

    result = perform_operation
    expect(result['model.seller_version'].started_at.to_i).to eq(application.started_at.to_i)
  end

  it 'fails when an version has already been submitted' do
    seller = create(:seller, owner: user)
    application = create(:awaiting_assignment_seller_version, seller: seller)

    result = perform_operation

    expect(result).to be_failure
  end
end
