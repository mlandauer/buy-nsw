require 'rails_helper'

RSpec.describe Products::BasicsForm do
  let(:product) { build_stubbed(:inactive_product) }
  subject { described_class.new(product) }

  let(:atts) {
    {
      name: 'Product-o-tron 2000',
      summary: "We name you product so you don't have to",
      audiences: ['developers'],
      reseller_type: 'extra-support',
      organisation_resold: 'The Original Cloud Co',
      custom_contact: true,
      contact_name: 'Other Contact',
      contact_email: 'other@example.org',
      contact_phone: '01234 567890',
      features: [
        'It does things',
      ],
      benefits: [
        'It benefits you',
      ],
    }
  }

  it 'validates with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
  end

  it 'is invalid when the name is blank' do
    subject.validate(atts.merge(name: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:name]).to be_present
  end

  it 'is invalid when the contact email address is not valid' do
    subject.validate(atts.merge(contact_email: 'foo'))

    expect(subject).to_not be_valid
    expect(subject.errors[:contact_email]).to be_present
  end

  describe '#features' do
    it 'is invalid when there are more than 10 features' do
      features = []
      11.times do
        features << 'It does things'
      end

      subject.validate(atts.merge(features: features))

      expect(subject).to_not be_valid
      expect(subject.errors[:features]).to be_present
    end

    it 'is valid when the features in excess of 10 are blank' do
      features = []
      10.times do
        features << 'It does things'
      end
      2.times do
        features << ''
      end
      subject.validate(atts.merge(features: features))

      expect(subject).to be_valid
    end

    context 'prepopulation' do
      it 'prepopulates two features by default' do
        subject.prepopulate!
        expect(subject.features.size).to eq(2)
      end

      it 'only adds one feature when 9 already exist' do
        subject.features = ['feature'] * 9
        subject.prepopulate!
        expect(subject.features.size).to eq(10)
      end

      it 'does not add any extra features when 10 already exist' do
        subject.features = ['feature'] * 10
        subject.prepopulate!
        expect(subject.features.size).to eq(10)
      end

      it 'does not add any extra features when more than 10 already exist' do
        subject.features = ['feature'] * 15
        subject.prepopulate!
        expect(subject.features.size).to eq(15)
      end
    end
  end
end
