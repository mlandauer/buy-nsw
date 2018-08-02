require 'rails_helper'

RSpec.describe Admin::BuildAssignSellerVersion do

  let(:version) { create(:awaiting_assignment_seller_version) }

  subject { described_class.new(seller_version_id: version.id) }

  describe '.call' do
    context 'given an existing version' do
      let(:operation) { described_class.call(seller_version_id: version.id) }

      it 'is successful' do
        expect(operation).to be_success
      end
    end

    context 'when the version does not exist' do
      it 'raises an exception' do
        expect{
          described_class.call(seller_version_id: '1234567')
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#form' do
    it 'returns a form for the seller version' do
      expect(subject.form).to be_a(Admin::SellerVersion::Contract::Assign)
      expect(subject.form.model).to eq(version)
    end
  end

  describe '#seller_version' do
    it 'returns the seller version' do
      expect(subject.seller_version).to eq(version)
    end
  end

end
