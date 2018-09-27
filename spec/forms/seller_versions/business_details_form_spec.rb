require 'rails_helper'

RSpec.describe SellerVersions::BusinessDetailsForm do
  subject { described_class.new(version) }

  let(:seller) { create(:inactive_seller) }
  let(:version) { build_stubbed(:seller_version, seller: seller) }

  let(:atts) do
    {
      name: 'OpenAustralia Foundation',
      abn: '24 138 089 942',
    }
  end

  it 'validates with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
  end

  it 'is invalid when the name is blank' do
    subject.validate(atts.merge(name: ''))

    expect(subject).not_to be_valid
    expect(subject.errors[:name]).to be_present
  end

  it 'is invalid when the ABN is blank' do
    subject.validate(atts.merge(abn: ''))

    expect(subject).not_to be_valid
    expect(subject.errors[:abn]).to be_present
  end

  it 'is invalid when the ABN is invalid' do
    subject.validate(atts.merge(abn: '10 123 456 789'))

    expect(subject).not_to be_valid
    expect(subject.errors[:abn]).to be_present
  end

  it 'is also valid when the ABN has no spaces' do
    subject.validate(atts.merge(abn: '24138089942'))

    expect(subject).to be_valid
  end

  it 'is invalid if the ABN has already been used' do
    create(:created_seller_version, abn: atts[:abn])

    subject.validate(atts)

    expect(subject).not_to be_valid
    expect(subject.errors[:abn]).to be_present
  end

  it 'is valid when the ABN is in use for another version of the same seller' do
    create(:approved_seller_version, seller: seller, abn: atts[:abn])
    subject.validate(atts)

    expect(subject).to be_valid
  end
end
