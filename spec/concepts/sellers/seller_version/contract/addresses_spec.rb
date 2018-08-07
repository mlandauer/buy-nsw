require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Contract::Addresses do
  let(:version) { build_stubbed(:seller_version) }
  subject { described_class.new(version) }

  let(:atts) {
    {
      addresses: [
        address_atts,
      ]
    }
  }
  let(:address_atts) {
    {
      address: '123 Test Street',
      suburb: 'Testville',
      state: 'nsw',
      country: 'AU',
      postcode: '2000',
    }
  }

  it 'validates with valid attributes' do
    subject.validate(atts)
    expect(subject.validate(atts)).to eq(true)
  end

  it 'is invalid without an address' do
    subject.validate(atts.merge(addresses: []))

    expect(subject).to_not be_valid
    expect(subject.errors[:addresses]).to be_present
  end

  context 'a nested address' do
    it 'is invalid when there is no street address' do
      address = address_atts.merge(address: nil)
      invalid_atts = atts.merge(addresses: [ address ])

      subject.validate(invalid_atts)

      expect(subject).to_not be_valid
      expect(subject.addresses[0].errors[:address]).to be_present
    end

    it 'is invalid when there is no suburb' do
      address = address_atts.merge(suburb: nil)
      invalid_atts = atts.merge(addresses: [ address ])

      subject.validate(invalid_atts)

      expect(subject).to_not be_valid
      expect(subject.addresses[0].errors[:suburb]).to be_present
    end

    it 'is invalid when there is no state' do
      address = address_atts.merge(state: nil)
      invalid_atts = atts.merge(addresses: [ address ])

      subject.validate(invalid_atts)

      expect(subject).to_not be_valid
      expect(subject.addresses[0].errors[:state]).to be_present
    end

    it 'is invalid when there is no postcode' do
      address = address_atts.merge(postcode: nil)
      invalid_atts = atts.merge(addresses: [ address ])

      subject.validate(invalid_atts)

      expect(subject).to_not be_valid
      expect(subject.addresses[0].errors[:postcode]).to be_present
    end
  end

  describe '#addresses' do
    let(:addresses) { [ address_atts ] * 3 }
    
    it 'adds a new address' do
      subject.validate({
        addresses: addresses + [address_atts],
      })

      expect(subject.addresses.size).to eq(4)
    end

    it 'removes an address when omitted' do
      subject.validate({
        addresses: addresses[0..1],
      })

      expect(subject.addresses.size).to eq(2)
    end
  end

  describe '#valid?' do
    context 'with a valid address' do
      before(:each) {
        subject.validate({
          addresses: [ address_atts ]
        })
      }

      it 'is true' do
        expect(subject).to be_valid
      end
    end

    context 'with an invalid address' do
      let(:invalid_atts) {
        {
          address: nil,
          suburb: nil,
          state: 'nsw',
          country: 'AU',
          postcode: nil,
        }
      }

      before(:each) {
        subject.validate({
          addresses: [ address_atts, invalid_atts ],
        })
      }

      it 'is false' do
        expect(subject).to_not be_valid
      end
    end
  end
end
