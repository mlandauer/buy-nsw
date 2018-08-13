require 'rails_helper'

RSpec.describe SellerVersions::RecognitionForm do
  let(:version) { create(:seller_version) }
  subject { described_class.new(version) }

  let(:atts) {
    {
      accreditations: [ 'Certified Test Case' ],
      awards: [ 'Test Case of the Year' ],
      engagements: [ 'Test Case Board Member' ],
    }
  }

  it 'can save accreditations' do
    subject.validate(atts)

    expect(subject).to be_valid
    expect(subject.save).to eq(true)

    version.reload

    expect(version.accreditations.count).to eq(1)
    expect(version.awards.count).to eq(1)
    expect(version.engagements.count).to eq(1)
  end

  it 'ignores blank accreditations' do
    subject.validate(atts.merge(
      accreditations: ['Item 1', '', 'Item 3']
    ))
    subject.save

    version.reload

    expect(version.accreditations.count).to eq(2)
    expect(version.accreditations).to contain_exactly(
      'Item 1', 'Item 3'
    )
  end

  it 'updates an accreditation' do
    version.update_attribute(:accreditations, [ 'Existing' ])

    subject.validate(atts.merge(
      accreditations: ['Updated']
    ))

    subject.save
    version.reload

    expect(version.accreditations).to contain_exactly('Updated')
  end

  it 'removes an accreditation given a blank value' do
    version.update_attribute(:accreditations, [ 'Existing' ])

    subject.validate(atts.merge(
      accreditations: ['']
    ))

    subject.save
    version.reload

    expect(version.accreditations.count).to eq(0)
  end
end
