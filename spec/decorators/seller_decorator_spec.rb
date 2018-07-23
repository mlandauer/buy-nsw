require 'rails_helper'

RSpec.describe SellerDecorator do

  let(:seller) { create(:seller) }
  let(:mock_context) { double('view context') }

  subject { SellerDecorator.new(seller, mock_context) }

  describe '#addresses' do
    it 'returns addresses wrapped in decorator objects' do
      create_list(:seller_address, 3, seller: seller)

      expect(subject.addresses.size).to eq(3)
      subject.addresses.each do |address|
        expect(address).to be_a(SellerAddressDecorator)
      end
    end
  end

  describe '#agreed_by_email' do
    context 'when a version exists' do
      let(:user) { create(:seller_user) }
      let!(:version) { create(:seller_version, seller: seller, agreed_by: user) }

      it 'returns the agreed by email from the first version' do
        expect(subject.agreed_by_email).to eq(user.email)
      end
    end

    context 'when no version exists' do
      it 'returns nil' do
        expect(subject.agreed_by_email).to be_blank
      end
    end
  end

end
