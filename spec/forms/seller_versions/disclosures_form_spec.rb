require 'rails_helper'

RSpec.describe SellerVersions::DisclosuresForm do
  subject { described_class.new(version) }

  let(:version) { build_stubbed(:seller_version) }

  let(:atts) do
    {
      receivership: true,
      investigations: true,
      legal_proceedings: true,
      insurance_claims: true,
      conflicts_of_interest: true,
      other_circumstances: true,

      receivership_details: 'Information',
      investigations_details: 'Information',
      legal_proceedings_details: 'Information',
      insurance_claims_details: 'Information',
      conflicts_of_interest_details: 'Information',
      other_circumstances_details: 'Information',
    }
  end

  context '#started?' do
    it 'returns true when a radio button is false' do
      subject.receivership = false
      expect(subject.started?).to be_truthy
    end
  end

  it 'validates with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
  end

  describe 'investigations' do
    it 'is valid when false and the details field is blank' do
      subject.validate(atts.merge(investigations: false, investigations_details: ''))

      expect(subject).to be_valid
    end

    it 'is invalid when true and the details field is blank' do
      subject.validate(atts.merge(investigations: true, investigations_details: ''))

      expect(subject).not_to be_valid
      expect(subject.errors[:investigations_details]).to be_present
    end
  end

  describe 'legal_proceedings' do
    it 'is valid when false and the details field is blank' do
      subject.validate(atts.merge(legal_proceedings: false, legal_proceedings_details: ''))

      expect(subject).to be_valid
    end

    it 'is invalid when true and the details field is blank' do
      subject.validate(atts.merge(legal_proceedings: true, legal_proceedings_details: ''))

      expect(subject).not_to be_valid
      expect(subject.errors[:legal_proceedings_details]).to be_present
    end
  end

  describe 'insurance_claims' do
    it 'is valid when false and the details field is blank' do
      subject.validate(atts.merge(insurance_claims: false, insurance_claims_details: ''))

      expect(subject).to be_valid
    end

    it 'is invalid when true and the details field is blank' do
      subject.validate(atts.merge(insurance_claims: true, insurance_claims_details: ''))

      expect(subject).not_to be_valid
      expect(subject.errors[:insurance_claims_details]).to be_present
    end
  end

  describe 'conflicts_of_interest' do
    it 'is valid when false and the details field is blank' do
      subject.validate(atts.merge(conflicts_of_interest: false, conflicts_of_interest_details: ''))

      expect(subject).to be_valid
    end

    it 'is invalid when true and the details field is blank' do
      subject.validate(atts.merge(conflicts_of_interest: true, conflicts_of_interest_details: ''))

      expect(subject).not_to be_valid
      expect(subject.errors[:conflicts_of_interest_details]).to be_present
    end
  end

  describe 'other_circumstances' do
    it 'is valid when false and the details field is blank' do
      subject.validate(atts.merge(other_circumstances: false, other_circumstances_details: ''))

      expect(subject).to be_valid
    end

    it 'is invalid when true and the details field is blank' do
      subject.validate(atts.merge(other_circumstances: true, other_circumstances_details: ''))

      expect(subject).not_to be_valid
      expect(subject.errors[:other_circumstances_details]).to be_present
    end
  end
end
