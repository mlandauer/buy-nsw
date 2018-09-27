require 'rails_helper'

RSpec.describe Buyers::BuildUpdateApplication do
  subject { described_class.new(user: buyer_user, form_class: form) }

  let(:buyer_user) { create(:inactive_buyer_user) }
  let(:form) { BuyerApplications::BasicDetailsForm }

  describe '.call' do
    def perform_operation(user: buyer_user, form_class: form)
      described_class.call(
        user: user,
        form_class: form_class,
      )
    end

    context 'with a valid buyer' do
      it 'is sucessful' do
        expect(perform_operation).to be_success
      end
    end

    context 'failure states' do
      it 'fails when the current user is blank' do
        operation = perform_operation(user: nil)

        expect(operation).to be_failure
      end

      it 'fails when the current user is not a buyer' do
        user = create(:seller_user)
        operation = perform_operation(user: user)

        expect(operation).to be_failure
      end

      it 'fails when the current user does not have a buyer record' do
        user = create(:user, roles: ['buyer'])
        operation = perform_operation(user: user)

        expect(operation).to be_failure
      end

      it 'fails when the buyer application is already approved' do
        buyer_user.buyer.update_attribute(:state, :approved)
        operation = perform_operation(user: buyer_user)

        expect(operation).to be_failure
      end
    end
  end

  describe '#form' do
    it 'returns the given form for the application' do
      expect(subject.form).to be_a(form)
      expect(subject.form.model).to be_a(BuyerApplication)
    end
  end

  describe '#application' do
    it 'returns the application' do
      expect(subject.application).to eq(buyer_user.buyer)
    end
  end
end
