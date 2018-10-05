require 'rails_helper'

RSpec.describe SellerVersionDecorator do
  subject { described_class.new(version, mock_context) }

  let(:version) { create(:seller_version) }
  let(:mock_context) { double('view context') }

  describe '#addresses' do
    it 'returns addresses wrapped in decorator objects' do
      version.update_attribute(:addresses, [attributes_for(:seller_address)] * 3)

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
