require 'rails_helper'

RSpec.describe Ops::UploadWaitingSellers do

  let(:csv_file) {
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec','fixtures','files','waiting_seller_list.csv')
    )
  }

  describe '#parse_from_csv' do

    describe 'given a CSV file' do
      it 'parses WaitingSeller objects' do
        result = described_class.call(file: csv_file)

        expect(result).to be_success
        expect(result.waiting_sellers.count).to eq(2)
        expect(result.waiting_sellers.first).to be_a(WaitingSeller)
      end

      it 'correctly assigns attributes' do
        result = described_class.call(file: csv_file)
        seller = result.waiting_sellers.first

        expect(seller.name).to eq('Smith-Churchill Enterprises')
        expect(seller.abn).to eq('42002780289')
        expect(seller.address).to eq('123 Test Street')
        expect(seller.suburb).to eq('Sydney')
        expect(seller.country).to eq('Australia')
        expect(seller.contact_name).to eq('Winston Smith-Churchill')
        expect(seller.contact_email).to eq('test-1@test.buy.nsw.gov.au')
        expect(seller.contact_position).to eq('Test')
        expect(seller.website_url).to eq('http://example.org')
      end

      it 'downcases the state field' do
        result = described_class.call(file: csv_file)
        seller = result.waiting_sellers.first

        expect(seller.state).to eq('nsw')
      end
    end

    describe 'given a base64-encoded string' do
      let(:string) { Base64.encode64(File.read(csv_file.path)) }

      it 'parses WaitingSeller objects' do
        result = described_class.call(file_contents: string)

        expect(result).to be_success
        expect(result.waiting_sellers.count).to eq(2)
        expect(result.waiting_sellers.first).to be_a(WaitingSeller)
      end

      it 'correctly assigns attributes' do
        result = described_class.call(file_contents: string)
        seller = result.waiting_sellers.first

        expect(seller.name).to eq('Smith-Churchill Enterprises')
        expect(seller.abn).to eq('42002780289')
        expect(seller.address).to eq('123 Test Street')
        expect(seller.suburb).to eq('Sydney')
        expect(seller.country).to eq('Australia')
        expect(seller.contact_name).to eq('Winston Smith-Churchill')
        expect(seller.contact_email).to eq('test-1@test.buy.nsw.gov.au')
        expect(seller.contact_position).to eq('Test')
        expect(seller.website_url).to eq('http://example.org')
      end

      it 'downcases the state field' do
        result = described_class.call(file_contents: string)
        seller = result.waiting_sellers.first

        expect(seller.state).to eq('nsw')
      end
    end

    it 'fails given a malformed CSV' do
      string = Base64.encode64('Foo",""",bar";')
      result = described_class.call(file_contents: string)

      expect(result).to be_failure
    end
  end

  describe '#validate_file' do
    it 'fails when the file and file_contents params are empty' do
      result = described_class.call(file: nil, file_contents: nil)

      expect(result).to be_failure
    end
  end

  describe "#validate_rows" do
    it 'fails when there are no WaitingSeller objects' do
      # Just use the header row
      contents = Base64.encode64(
        File.read(csv_file.path).split("\n").first
      )
      result = described_class.call(file_contents: contents)

      expect(result).to be_failure
    end
  end

  describe '#persist_rows' do
    it 'does not persist rows when the "persist" parameter is false' do
      result = described_class.call(file: csv_file, persist: false)

      expect(result).to_not be_persisted
      expect(WaitingSeller.count).to eq(0)
    end

    it 'persists rows when the "persist" parameter is false' do
      result = described_class.call(file: csv_file, persist: true)

      expect(result).to be_success
      expect(result).to be_persisted
      expect(WaitingSeller.count).to eq(2)
    end

    it 'normalises the ABN on save' do
      result = described_class.call(file: csv_file, persist: true)
      seller = result.waiting_sellers.first

      expect(seller.abn).to eq('42 002 780 289')
    end
  end

end
