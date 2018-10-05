require 'rails_helper'

RSpec.describe SellerVersions::WorkersCompensationForm do
  subject { described_class.new(version) }

  let(:version) { create(:seller_version) }

  let(:example_pdf) do
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec', 'fixtures', 'files', 'example.pdf'),
      'application/pdf'
    )
  end
  let(:future_date) { Date.today + 1.year }
  let(:historical_date) { Date.today - 1.year }

  context '#started?' do
    it 'returns false when all fields are empty' do
      expect(subject.started?).to be_falsey
    end

    it 'returns false when all fields are empty and workers_compensation_exempt is false' do
      subject.workers_compensation_exempt = false
      expect(subject.started?).to be_falsey
    end
  end

  it 'is invalid when all blank' do
    subject.validate({
      "workers_compensation_exempt": '0',
      "workers_compensation_certificate_expiry(3i)": '',
      "workers_compensation_certificate_expiry(2i)": '',
      "workers_compensation_certificate_expiry(1i)": '',
    })

    expect(subject).not_to be_valid
  end

  context 'for a seller not exempt from workers compensation insurance' do
    let(:atts) do
      {
        workers_compensation_certificate_file: example_pdf,
        workers_compensation_certificate_expiry: future_date,
        workers_compensation_exempt: false,
      }
    end

    it 'validates with valid attributes' do
      expect(subject.validate(atts)).to eq(true)
    end

    context 'workers_compensation_certificate_file' do
      it 'is invalid when blank' do
        subject.validate(atts.merge(workers_compensation_certificate_file: nil))

        expect(subject).not_to be_valid
        expect(subject.errors[:workers_compensation_certificate_file]).to be_present
      end

      it 'is invalid with an unsupported filetype' do
        invalid_file = Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'fixtures', 'files', 'invalid.html')
        )
        subject.validate(atts.merge(
          workers_compensation_certificate_file: invalid_file
        ))

        expect(subject.save).to be_falsey
      end

      it 'is invalid with an unsupported content type' do
        invalid_file = Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'fixtures', 'files', 'example.pdf'),
          'text/html'
        )
        subject.validate(atts.merge(
          workers_compensation_certificate_file: invalid_file
        ))

        expect(subject.save).to be_falsey
      end
    end

    context 'workers_compensation_certificate_expiry' do
      it 'is invalid when blank' do
        subject.validate(atts.merge(workers_compensation_certificate_expiry: nil))

        expect(subject).not_to be_valid
        expect(subject.errors[:workers_compensation_certificate_expiry]).to be_present
      end

      it 'is invalid when in the past' do
        subject.validate(atts.merge(workers_compensation_certificate_expiry: historical_date))

        expect(subject).not_to be_valid
        expect(subject.errors[:workers_compensation_certificate_expiry]).to be_present
      end
    end
  end

  context 'for a seller exempt from workers compensation insurance' do
    let(:atts) do
      {
        workers_compensation_certificate_file: nil,
        workers_compensation_certificate_expiry: nil,
        workers_compensation_exempt: true,
      }
    end

    it 'is valid when the certificate and expiry are blank' do
      expect(subject.validate(atts)).to eq(true)
    end
  end
end
