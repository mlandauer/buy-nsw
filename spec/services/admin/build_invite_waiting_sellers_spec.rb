require 'rails_helper'

RSpec.describe Admin::BuildInviteWaitingSellers do

  let(:waiting_sellers) { create_list(:waiting_seller, 5) }
  let(:waiting_seller_ids) { waiting_sellers.map(&:id) }

  describe '.call' do
    context 'given valid arguments' do
      subject {
        described_class.call(waiting_seller_ids: waiting_seller_ids)
      }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'returns false for no_sellers_selected?' do
        expect(subject).to_not be_no_sellers_selected
      end
    end

    context 'given no IDs' do
      subject {
        described_class.call(waiting_seller_ids: nil)
      }

      it 'fails' do
        expect(subject).to be_failure
      end

      it 'returns true for no_sellers_selected?' do
        expect(subject).to be_no_sellers_selected
      end
    end

    context 'given a non-existent ID' do
      subject {
        described_class.call(waiting_seller_ids: ['abc'])
      }

      it 'raises an exception' do
        expect{ subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'given a waiting seller already invited' do
      let(:waiting_seller) { create(:invited_waiting_seller) }

      subject {
        described_class.call(waiting_seller_ids: [ waiting_seller.id ])
      }

      it 'raises an exception' do
        expect{ subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when a seller is invalid' do
      let(:invalid_seller) { create(:waiting_seller, name: '') }

      subject {
        described_class.call(waiting_seller_ids: [ invalid_seller.id ])
      }

      it 'fails' do
        expect(subject).to be_failure
      end

      it 'includes the seller in the invalid list' do
        expect(subject.invalid_waiting_sellers).to contain_exactly(invalid_seller)
      end
    end
  end

end
