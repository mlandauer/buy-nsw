require 'rails_helper'

RSpec.describe SellerVersions::ServicesForm do
  subject { described_class.new(version) }

  let(:version) { create(:seller_version) }

  let(:atts) do
    {
      offers_cloud: 'true',
      govdc: 'false',
      services: [
        'managed-services',
        'software-development',
      ],
    }
  end

  it 'validates with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
  end

  it 'is valid when no other non-cloud services are selected' do
    subject.validate(atts.merge(services: ['']))
    expect(subject).to be_valid

    subject.save
    expect(version.reload.services).to eq(['cloud-services'])
  end

  it 'is invalid given a service that is not in the pre-existing list' do
    subject.validate(atts.merge(services: ['baking']))

    expect(subject).not_to be_valid
    expect(subject.errors[:services]).to be_present
  end

  it 'is valid with blank values provided in the list' do
    subject.validate(atts.merge(
      services: ['cloud-services', '']
    ))

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  describe 'cloud-services' do
    it 'appends "cloud-services" to the list when "offers_cloud" is true' do
      subject.validate(atts)
      subject.save

      expect(version.reload.services).to include('cloud-services')
    end

    it 'does not append "cloud-services" to the list when "offers_cloud" is false' do
      subject.validate(atts.merge(offers_cloud: 'false'))
      subject.save

      expect(version.reload.services).not_to include('cloud-services')
    end

    it 'removes "cloud-services" from the list when "offers_cloud" is false' do
      version.update_attribute(:services, ['cloud-services', 'managed-services'])

      subject.validate(atts.merge(offers_cloud: 'false'))
      subject.save!

      expect(version.reload.services).not_to include('cloud-services')
    end
  end

  describe 'infrastructure' do
    it 'appends "infrastructure" to the list when "govdc" is true' do
      subject.validate(atts.merge(govdc: 'true'))
      subject.save

      expect(version.reload.services).to include('infrastructure')
    end

    it 'does not append "infrastructure" to the list when "govdc" is false' do
      subject.validate(atts.merge(govdc: 'false'))
      subject.save

      expect(version.reload.services).not_to include('infrastructure')
    end
  end

  it 'is invalid when both "govdc" and "offers_cloud" is false' do
    subject.validate(atts.merge(offers_cloud: 'false', govdc: 'false'))

    expect(subject).not_to be_valid
    expect(subject.errors[:eligible_seller]).to be_present
  end

  it 'is invalid when "offers_cloud" is false and there are products' do
    create(:product, seller: version.seller)
    subject.validate(atts.merge(offers_cloud: 'false', govdc: 'true'))

    expect(subject).not_to be_valid
    expect(subject.errors[:offers_cloud]).to be_present
  end
end
