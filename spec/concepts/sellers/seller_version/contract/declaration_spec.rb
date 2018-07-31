require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Contract::Declaration do

  let(:seller_version) { build_stubbed(:seller_version) }
  subject { described_class.new(seller_version: seller_version, seller: seller_version.seller) }

  it 'validates with terms acceptance' do
    expect(subject.validate({
      agree: true
    })).to eq(true)
  end

  it 'is invalid when terms are not accepted' do
    subject.validate({
      agree: false
    })

    expect(subject).to_not be_valid
    expect(subject.errors[:agree]).to be_present
  end

  describe '#representative_details_provided?' do
    context 'when all details are provided' do
      let(:seller_version) {
        build_stubbed(
          :seller_version,
          representative_name: 'Name',
          representative_email: 'Email',
          representative_phone: '01253 123456',
          representative_position: 'Position'
        )
      }

      it 'returns true' do
        expect(subject.representative_details_provided?).to be_truthy
      end
    end

    context 'when details are missing' do
      let(:seller_version) {
        build_stubbed(
          :seller_version,
          representative_name: 'Name',
          representative_email: nil,
          representative_phone: nil,
          representative_position: nil
        )
      }

      it 'returns true' do
        expect(subject.representative_details_provided?).to be_falsey
      end
    end
  end

  describe '#business_details_provided?' do
    context 'when all details are provided' do
      let(:seller_version) { build_stubbed(:seller_version, name: 'Name',
      abn: 'ABN') }

      it 'returns true' do
        expect(subject.business_details_provided?).to be_truthy
      end
    end

    context 'when details are missing' do
      let(:seller_version) {
        build_stubbed(
          :seller_version,
          name: 'Name',
          abn: nil
        )
      }

      it 'returns true' do
        expect(subject.business_details_provided?).to be_falsey
      end
    end
  end
end
