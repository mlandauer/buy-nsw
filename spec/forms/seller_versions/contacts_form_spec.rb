require 'rails_helper'

RSpec.describe SellerVersions::ContactsForm do
  subject { described_class.new(version) }

  let(:version) { build_stubbed(:seller_version) }

  let(:atts) do
    {
      contact_name: 'Test User',
      contact_email: 'test@example.org',
      contact_phone: '02 9123 4567',
      representative_name: 'Representative User',
      representative_email: 'representative@example.org',
      representative_phone: '02 9765 4321',
      representative_position: 'CEO',
    }
  end

  it 'validates with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
  end

  it 'is invalid when the contact name is blank' do
    subject.validate(atts.merge(contact_name: nil))

    expect(subject).not_to be_valid
    expect(subject.errors[:contact_name]).to be_present
  end

  it 'is invalid when the contact email is blank' do
    subject.validate(atts.merge(contact_email: nil))

    expect(subject).not_to be_valid
    expect(subject.errors[:contact_email]).to be_present
  end

  it 'is invalid when the contact email is not valid' do
    subject.validate(atts.merge(contact_email: 'foo.com'))

    expect(subject).not_to be_valid
    expect(subject.errors[:contact_email]).to be_present
  end

  it 'is invalid when the contact phone is blank' do
    subject.validate(atts.merge(contact_phone: nil))

    expect(subject).not_to be_valid
    expect(subject.errors[:contact_phone]).to be_present
  end

  it 'is invalid when the representative name is blank' do
    subject.validate(atts.merge(representative_name: nil))

    expect(subject).not_to be_valid
    expect(subject.errors[:representative_name]).to be_present
  end

  it 'is invalid when the representative email is blank' do
    subject.validate(atts.merge(representative_email: nil))

    expect(subject).not_to be_valid
    expect(subject.errors[:representative_email]).to be_present
  end

  it 'is invalid when the representative email is not valid' do
    subject.validate(atts.merge(representative_email: 'foo'))

    expect(subject).not_to be_valid
    expect(subject.errors[:representative_email]).to be_present
  end

  it 'is invalid when the representative phone is blank' do
    subject.validate(atts.merge(representative_phone: nil))

    expect(subject).not_to be_valid
    expect(subject.errors[:representative_phone]).to be_present
  end
end
