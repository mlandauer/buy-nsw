require 'rails_helper'

RSpec.describe Sellers::WaitingSeller::Accept do
  let(:waiting_seller) { create(:invited_waiting_seller) }

  def perform_operation(params = {})
    described_class.call({ id: waiting_seller.invitation_token, invitation: params })
  end

  let(:default_params) do
    {
      password: 'a long secure password',
      password_confirmation: 'a long secure password',
    }
  end

  describe '::Present' do
    subject { Sellers::WaitingSeller::Accept::Present }

    it 'is successful given a valid token' do
      result = subject.call({ id: waiting_seller.invitation_token })

      expect(result).to be_success
    end

    it 'assigns the model' do
      result = subject.call({ id: waiting_seller.invitation_token })

      expect(result['model']).to eq(waiting_seller)
    end

    it 'raises an exception given an invalid token' do
      expect do
        subject.call({ id: 'invalid-token' })
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises an exception given a token for a non-invited object' do
      other_waiting_seller = create(:waiting_seller, invitation_token: 'foo')

      expect do
        subject.call({ id: other_waiting_seller.invitation_token })
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    describe '#check_seller_does_not_exist!' do
      it 'fails when the ABN already exists' do
        create(:seller_version, abn: waiting_seller.abn)
        result = subject.call({ id: waiting_seller.invitation_token })

        expect(result).to be_failure
        expect(result['errors']).to include('seller_exists')
      end
    end
  end

  it 'is successful given valid parameters' do
    result = perform_operation(default_params)

    expect(result).to be_success
  end

  describe '#create_user!' do
    it 'creates a user from the WaitingSeller attributes' do
      expect do
        perform_operation(default_params)
      end.to change(User, :count).from(0).to(1)

      user = User.last
      expect(user.email).to eq(waiting_seller.contact_email)
      expect(user.roles).to contain_exactly('seller')
    end

    it 'correctly sets the password' do
      result = perform_operation(default_params)

      expect(result['user'].password).to eq(default_params[:password])
    end

    it 'auto-confirms the user' do
      result = perform_operation(default_params)

      expect(result['user'].confirmed_at).to be_present
    end

    it 'fails when the user already exists' do
      create(:user, email: waiting_seller.contact_email)
      result = perform_operation(default_params)

      expect(result).to be_failure
      expect(result['errors']).to include('user_exists')
    end

    it 'fails and passes through Devise errors when the user is invalid' do
      # Cause an error to be returned from Devise
      result = perform_operation({
        password: '',
        password_confirmation: '',
      })

      expect(result).to be_failure
      expect(result['contract.default'].errors[:password]).to be_present
    end
  end

  describe '#create_seller!' do
    it 'creates a seller from the WaitingSeller attributes' do
      expect do
        perform_operation(default_params)
      end.to change(Seller, :count).from(0).to(1)
    end
  end

  describe '#create_version!' do
    it 'creates a seller version for the newly-created seller' do
      expect do
        perform_operation(default_params)
      end.to change(SellerVersion, :count).from(0).to(1)

      seller = Seller.last
      version = SellerVersion.last
      address = version.addresses.first

      expect(version.seller).to eq(seller)
      expect(version.name).to eq(waiting_seller.name)
      expect(version.abn).to eq(waiting_seller.abn)
      expect(version.contact_name).to eq(waiting_seller.contact_name)
      expect(version.contact_email).to eq(waiting_seller.contact_email)
      expect(version.website_url).to eq(waiting_seller.website_url)

      expect(address.address).to eq(waiting_seller.address)
      expect(address.suburb).to eq(waiting_seller.suburb)
      expect(address.state).to eq(waiting_seller.state)
      expect(address.postcode).to eq(waiting_seller.postcode)
    end

    it 'sets the "started_at" timestamp' do
      time = 1.hour.ago

      Timecop.freeze(time) do
        perform_operation(default_params)
      end
      version = SellerVersion.last

      expect(version.started_at.to_i).to eq(time.to_i)
    end
  end

  describe '#log_event!' do
    it 'logs an "application started" event' do
      result = perform_operation(default_params)

      expect(result['application'].events.last.message).to eq("Started application")
      expect(result['application'].events.last.user).to eq(result['user'])
    end
  end

  describe '#update_seller_assignment!' do
    it 'assigns the newly-created seller to the newly-created user' do
      result = perform_operation(default_params)

      expect(result['user'].seller).to eq(result['seller'])
    end
  end

  describe '#update_invitation_state!' do
    it 'updates the invitation state of the WaitingSeller' do
      expect do
        perform_operation(default_params)
      end.to change {
        waiting_seller.reload.invitation_state
      }.from('invited').to('joined')
    end

    it 'clears the invitation token' do
      perform_operation(default_params)

      expect(waiting_seller.reload.invitation_token).to be_nil
    end

    it 'assigns the seller to the WaitingSeller' do
      result = perform_operation(default_params)

      expect(waiting_seller.reload.seller).to eq(result['seller'])
    end

    it 'sets the "joined_at" timestamp' do
      time = 1.hour.ago

      Timecop.freeze(time) do
        perform_operation(default_params)
      end

      expect(waiting_seller.reload.joined_at.to_i).to eq(time.to_i)
    end
  end
end
