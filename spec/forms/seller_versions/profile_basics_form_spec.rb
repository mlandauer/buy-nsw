require 'rails_helper'

RSpec.describe SellerVersions::ProfileBasicsForm do
  subject { described_class.new(version) }

  let(:version) { build_stubbed(:seller_version) }

  let(:atts) do
    {
      summary: 'Summary',
      website_url: 'http://example.org',
      linkedin_url: 'http://linkedin.com/example',
    }
  end

  it 'validates with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
  end

  it 'is invalid when the website URL is blank' do
    subject.validate(atts.merge(website_url: ''))

    expect(subject).not_to be_valid
    expect(subject.errors[:website_url]).to be_present
  end

  it 'is invalid when a bad website URL is given' do
    subject.validate(atts.merge(website_url: 'foo'))

    expect(subject).not_to be_valid
    expect(subject.errors[:website_url]).to be_present
  end

  it 'is invalid when a bad linkedin url is given' do
    subject.validate(atts.merge(linkedin_url: 'foo'))

    expect(subject).not_to be_valid
    expect(subject.errors[:linkedin_url]).to be_present
  end

  context 'summary' do
    it 'is invalid when blank' do
      subject.validate(atts.merge(summary: ''))

      expect(subject).not_to be_valid
      expect(subject.errors[:summary]).to be_present
    end

    it 'is valid when less than 50 words' do
      summary = (1..49).map { |n| 'word' }.join(' ')
      subject.validate(atts.merge(summary: summary))

      expect(subject).to be_valid
    end

    it 'is valid when 50 words' do
      summary = (1..50).map { |n| 'word' }.join(' ')
      subject.validate(atts.merge(summary: summary))

      expect(subject).to be_valid
    end

    it 'is invalid when longer than 50 words' do
      summary = (1..51).map { |n| 'word' }.join(' ')
      subject.validate(atts.merge(summary: summary))

      expect(subject).not_to be_valid
      expect(subject.errors[:summary]).to be_present
    end
  end
end
