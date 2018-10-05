require 'rails_helper'

RSpec.describe SellerVersions::CharacteristicsForm do
  subject { described_class.new(version) }

  let(:version) { build_stubbed(:seller_version) }

  let(:atts) do
    {
      number_of_employees: '2to4',
      corporate_structure: 'standalone',
      start_up: true,
      sme: true,
      not_for_profit: false,
      australian_owned: true,
      regional: true,
      disability: false,
      female_owned: true,
      indigenous: false,
      no_experience: false,
      local_government_experience: true,
      state_government_experience: true,
      federal_government_experience: false,
      international_government_experience: true,
    }
  end

  it 'validates with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
  end

  it 'is invalid when the number of employees is blank' do
    subject.validate(atts.merge(number_of_employees: nil))

    expect(subject).not_to be_valid
    expect(subject.errors[:number_of_employees]).to be_present
  end

  it 'is invalid when the number of employees is not a valid value' do
    subject.validate(atts.merge(number_of_employees: 'something else'))

    expect(subject).not_to be_valid
    expect(subject.errors[:number_of_employees]).to be_present
  end
end
