require 'rails_helper'

RSpec.describe Sellers::BuildAcceptInvitation do

  let(:token) { 'my-confirmation-token' }

  let!(:version) { create(:created_seller_version) }
  let!(:invited_user) {
    create(:seller_user, seller: version.seller,
                         confirmed_at: nil,
                         confirmation_token: token)
  }

  def perform_operation(**args)
    options = {
      version_id: version.id,
      confirmation_token: token,
    }

    described_class.call(options.merge(**args))
  end

  subject { perform_operation }

  describe '.call' do
    context 'with valid arguments' do
      it 'succeeds' do
        expect(subject).to be_success
      end
    end

    context 'when the version ID is blank' do
      subject { perform_operation(version_id: nil) }

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'when the version does not exist' do
      subject { perform_operation(version_id: 'foo') }

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'when the version state is not "created"' do
      let(:other_version) { create(:approved_seller_version) }
      subject { perform_operation(version_id: other_version.id) }

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'when the confirmation token is blank' do
      subject { perform_operation(confirmation_token: nil) }

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'when the confirmation token is incorrect' do
      subject { perform_operation(confirmation_token: 'foo') }

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'when the user does not belong to the seller' do
      let(:other_token) { 'not this one' }

      let(:user) {
        create(:seller_user, confirmed_at: Time.now, confirmation_token: other_token)
      }

      subject { perform_operation(confirmation_token: other_token) }

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'when the user is already confirmed' do
      before(:each) {
        invited_user.update_attribute(:confirmed_at, Time.now)
      }

      it 'fails' do
        expect(subject).to be_failure
      end
    end
  end

  describe '#form' do
    it 'returns the accept invitation form' do
      expect(subject.form).to be_a(Sellers::AcceptInvitationForm)
      expect(subject.form.model).to be_a(User)
    end
  end

  describe '#version' do
    it 'returns the seller version' do
      expect(subject.version).to eq(version)
    end
  end

  describe '#user' do
    it 'returns the user' do
      expect(subject.user).to eq(invited_user)
    end
  end

end
