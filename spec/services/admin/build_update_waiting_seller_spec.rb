require 'rails_helper'

RSpec.describe Admin::BuildUpdateWaitingSeller do
  let(:waiting_seller) { create(:waiting_seller) }

  describe '.call' do
    subject do
      described_class.call(waiting_seller_id: waiting_seller.id)
    end

    context 'given valid arguments' do
      it 'is successful' do
        expect(subject).to be_success
      end

      it 'assigns the model' do
        expect(subject.waiting_seller).to eq(waiting_seller)
      end

      it 'assigns the form' do
        expect(subject.form).to be_a(Admin::UpdateWaitingSellerForm)
        expect(subject.form.model).to eq(waiting_seller)
      end
    end

    context 'with an invalid model' do
      before(:each) do
        # The 'name' attribute is required in the form validation
        # in Admin::WaitingSeller::Contract::Update
        #
        waiting_seller.update_attribute(:name, '')
      end

      context 'when skip_prevalidate is false' do
        subject do
          described_class.call(
            waiting_seller_id: waiting_seller.id,
            skip_prevalidate: false,
          )
        end

        it 'prevalidates the form' do
          expect(subject.form.errors).not_to be_empty
        end
      end

      context 'when skip_prevalidate is true' do
        subject do
          described_class.call(
            waiting_seller_id: waiting_seller.id,
            skip_prevalidate: true,
          )
        end

        it 'does not prevalidate the form' do
          expect(subject.form.errors).to be_empty
        end
      end
    end

    context 'given an invalid model ID' do
      subject { described_class.call(waiting_seller_id: '12345678') }

      it 'fails' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'given a WaitingSeller not in the "created" state' do
      subject { described_class.call(waiting_seller_id: other_seller.id) }

      let(:other_seller) { create(:invited_waiting_seller) }

      it 'fails' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
