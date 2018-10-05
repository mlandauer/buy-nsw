require 'rails_helper'

RSpec.describe User do
  describe '#is_admin?' do
    it 'is true when a user has the role "admin"' do
      user = User.new(roles: ['admin'])
      expect(user.is_admin?).to be_truthy
    end

    it 'is false when a user does not have the role "admin"' do
      user = User.new(roles: [])
      expect(user.is_admin?).to be_falsey
    end
  end

  describe '#is_seller?' do
    it 'is true when a user has the role "seller"' do
      user = User.new(roles: ['seller'])
      expect(user.is_seller?).to be_truthy
    end

    it 'is false when a user does not have the role "seller"' do
      # TODO: change this once we remove the default role value to be 'seller'
      user = User.new(roles: ['buyer'])

      expect(user.is_seller?).to be_falsey
    end
  end

  describe '#is_buyer?' do
    it 'is true when a user has the role "buyer"' do
      user = User.new(roles: ['buyer'])
      expect(user.is_buyer?).to be_truthy
    end

    it 'is false when a user does not have the role "buyer"' do
      user = User.new(roles: [])
      expect(user.is_buyer?).to be_falsey
    end
  end

  describe '#discarded_at?' do
    it 'discarded_at flag is nil as default when creating a new user' do
      user = User.new(roles: ['seller'])
      expect(user.discarded?).to be_falsey
    end

    it 'is true when a user is discarded' do
      user = User.new(roles: ['seller'])
      user.discard
      expect(user.discarded?).to be_truthy
    end
  end

  describe '#is_active_buyer?' do
    it 'is true when the user has the "buyer" role and an approved buyer application' do
      user = create(:user, roles: ['buyer'])
      create(:approved_buyer_application, user: user)

      expect(user.is_active_buyer?).to be_truthy
    end

    it 'is false when the user has no associated buyer application' do
      user = User.new(roles: ['buyer'])

      expect(user.is_active_buyer?).to be_falsey
    end

    it 'is false when the user has a non-approved buyer application' do
      user = create(:user, roles: ['buyer'])
      create(:created_buyer_application, user: user)

      expect(user.is_active_buyer?).to be_falsey
    end
  end

  describe '#has_seller_version?' do
    it 'is true when there are associated seller versions' do
      user = create(:user)
      seller = create(:seller, owner: user)
      create(:seller_version, seller: seller)

      expect(user.has_seller_version?).to be_truthy
    end

    it 'is false when there are no associated seller versions' do
      user = User.new
      expect(user.has_seller_version?).to be_falsey
    end
  end

  describe '.with_role' do
    it 'returns only users with the specified role' do
      create_list(:admin_user, 5)
      create_list(:buyer_user, 3)
      create_list(:seller_user, 1)

      expect(User.with_role('admin').size).to eq(5)
      expect(User.with_role('buyer').size).to eq(3)
      expect(User.with_role('seller').size).to eq(1)
    end
  end
end
