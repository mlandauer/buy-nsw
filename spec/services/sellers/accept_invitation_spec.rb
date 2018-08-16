require 'rails_helper'

RSpec.describe Sellers::AcceptInvitation do

  let(:token) { 'my-confirmation-token' }
  let(:password) { 'foo bar baz' }

  let!(:version) { create(:created_seller_version) }
  let!(:invited_user) {
    create(:seller_user, seller: version.seller,
                         confirmed_at: nil,
                         confirmation_token: token)
  }

  let(:user_attributes) {
    {
      password: password,
      password_confirmation: password,
    }
  }

  def perform_operation(**args)
    options = {
      version_id: version.id,
      confirmation_token: token,
      user_attributes: user_attributes,
    }

    described_class.call(options.merge(**args))
  end

  subject { perform_operation }

  describe '.call' do
    context 'with valid arguments' do
      it 'succeeds' do
        expect(subject).to be_success
      end

      it 'confirms the user' do
        expect(subject.user.reload.confirmed_at).to be_present
      end

      it 'updates the password' do
        expect(subject.user).to be_valid_password(password)
      end
    end

    context 'when Sellers::BuildAcceptInvitation fails' do
      before(:each) do
        expect(Sellers::BuildAcceptInvitation).to receive(:call).
          with(version_id: version.id, confirmation_token: token).
          and_return(
            double(success?: false, failure?: true)
          )
      end

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'with errors on the User model' do
      # NOTE: 'password' is an insecure password (when validated by zxcvbn) so
      # it will fail the validation.
      #
      let(:password) { 'password' }

      it 'sets them on the form' do
        expect(subject).to be_failure
        expect(subject.form.errors[:password]).to be_present
      end
    end
  end

end
