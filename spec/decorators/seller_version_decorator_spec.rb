require 'rails_helper'

RSpec.describe SellerVersionDecorator do

  let(:version) { create(:seller_version) }
  let(:mock_context) { double('view context') }

  subject { described_class.new(version, mock_context) }

  describe '#addresses' do
    it 'returns addresses wrapped in decorator objects' do
      create_list(:seller_address, 3, seller: version.seller)

      expect(subject.addresses.size).to eq(3)
      subject.addresses.each do |address|
        expect(address).to be_a(SellerAddressDecorator)
      end
    end
  end

  describe '#agreed_by_email' do
    let(:user) { create(:seller_user) }
    let(:version) { create(:seller_version, agreed_by: user) }

    it 'returns the agreed by email from the first version' do
      expect(subject.agreed_by_email).to eq(user.email)
    end
  end

end
