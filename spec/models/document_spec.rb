require 'rails_helper'

RSpec.describe Document do

  let(:documentable) { create(:inactive_seller) }
  let(:attributes) { attributes_for(:document) }

  describe '#valid?' do
    context 'with all attributes' do
      subject { Document.new(attributes) }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'without a document' do
      subject { Document.new(attributes.merge(document: nil)) }

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors.keys).to include(:document)
      end
    end

    describe 'immutability' do
      context 'on create' do
        subject { Document.new(attributes) }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'on update with changes' do
        subject { Document.create!(attributes) }

        before(:each) {
          subject.original_filename = 'foo.jpg'
        }

        it 'is invalid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to include(:base)
        end
      end

      context 'on update with only scan_status changes' do
        subject { Document.create!(attributes) }

        before(:each) {
          subject.scan_status = :clean
        }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end
    end
  end

  describe '#scan_status' do
    it 'is unscanned by default' do
      expect(Document.new.scan_status).to eq('unscanned')
    end
  end

  describe '#mark_as_clean!' do
    subject { Document.create!(attributes) }

    it 'sets the scan_status to clean' do
      expect(subject.mark_as_clean!).to be_truthy
      expect(subject.reload.scan_status).to eq('clean')
    end
  end

  describe '#mark_as_infected!' do
    subject { Document.create!(attributes) }

    it 'sets the scan_status to infected' do
      expect(subject.mark_as_infected!).to be_truthy
      expect(subject.reload.scan_status).to eq('infected')
    end
  end

  describe '#reset_scan_status!' do

    context 'when infected' do
      subject { Document.create!(attributes) }

      before(:each) {
        subject.mark_as_infected!
      }

      it 'resets the scan_status to unscanned' do
        expect(subject.reset_scan_status!).to be_truthy
        expect(subject.reload.scan_status).to eq('unscanned')
      end
    end

    context 'when clean' do
      subject { Document.create!(attributes) }

      before(:each) {
        subject.mark_as_clean!
      }

      it 'resets the scan_status to unscanned' do
        expect(subject.reset_scan_status!).to be_truthy
        expect(subject.reload.scan_status).to eq('unscanned')
      end
    end

  end

  describe '#update_document_attributes' do
    context 'on create' do
      subject { Document.create!(attributes).reload }
      let(:file) { attributes[:document] }

      it 'sets the content_type' do
        expect(subject.content_type).to eq(file.content_type)
      end

      it 'sets the original_filename' do
        expect(subject.original_filename).to eq(file.original_filename)
      end
    end
  end

  describe '#scan_file' do
    subject { Document.new(attributes) }

    it 'queues the DocumentScanJob on create' do
      expect(DocumentScanJob).to receive(:perform_later).with(subject)
      subject.save
    end
  end
end
