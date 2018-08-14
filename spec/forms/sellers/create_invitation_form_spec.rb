require 'rails_helper'

RSpec.describe Sellers::CreateInvitationForm do
  let(:application) { build_stubbed(:seller_version) }
  let(:user) { build_stubbed(:seller_user, seller: application.seller) }

  subject { described_class.new(user) }

  it 'is valid with valid attributes' do
    subject.validate({email: 'foo@bar.com'})

    expect(subject).to be_valid
  end

  it 'is invalid with a bad email address' do
    subject.validate({email: 'foobar.com'})

    expect(subject).to_not be_valid
  end
end
