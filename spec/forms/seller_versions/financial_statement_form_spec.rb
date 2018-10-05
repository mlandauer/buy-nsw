require 'rails_helper'

RSpec.describe SellerVersions::FinancialStatementForm do
  subject { described_class.new(version) }

  let(:version) { create(:seller_version) }

  let(:example_pdf) do
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec', 'fixtures', 'files', 'example.pdf'),
      'application/pdf'
    )
  end
  let(:historical_date) { Date.today - 1.year }

  let(:atts) do
    {
      financial_statement_file: example_pdf,
      financial_statement_expiry: historical_date,
    }
  end

  it 'validates with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
  end

  context 'financial_statement_file' do
    it 'is invalid when blank' do
      subject.validate(atts.merge(financial_statement_file: nil))

      expect(subject).not_to be_valid
      expect(subject.errors[:financial_statement_file]).to be_present
    end

    it 'is invalid with an unsupported filetype' do
      invalid_file = Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'files', 'invalid.html')
      )
      subject.validate(atts.merge(
        financial_statement_file: invalid_file
      ))

      expect(subject.save).to be_falsey
    end

    it 'is invalid with an unsupported content type' do
      invalid_file = Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'files', 'example.pdf'),
        'text/html'
      )
      subject.validate(atts.merge(
        financial_statement_file: invalid_file
      ))

      expect(subject.save).to be_falsey
    end
  end

  context 'financial_statement_expiry' do
    it 'is invalid when blank' do
      subject.validate(atts.merge(financial_statement_expiry: nil))

      expect(subject).not_to be_valid
      expect(subject.errors[:financial_statement_expiry]).to be_present
    end
  end

  context 'given multi-parameter dates' do
    it 'builds a valid expiry date' do
      subject.validate(
        atts.except(:financial_statement_expiry).merge(
          "financial_statement_expiry(3i)" => historical_date.day,
          "financial_statement_expiry(2i)" => historical_date.month,
          "financial_statement_expiry(1i)" => historical_date.year,
        )
      )

      expect(subject).to be_valid
      expect(subject.financial_statement_expiry).to eq(historical_date)
    end
  end
end
