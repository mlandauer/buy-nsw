require 'rails_helper'

RSpec.describe Sellers::CreateInvitationForm do
  subject { described_class.new(user) }

  let(:application) { build_stubbed(:seller_version) }
  let(:user) { build_stubbed(:seller_user, seller: application.seller) }

  it 'is valid with valid attributes' do
    subject.validate({ email: 'foo@bar.com' })

    expect(subject).to be_valid
  end

  it 'is invalid with a bad email address' do
    subject.validate({ email: 'foobar.com' })

    expect(subject).not_to be_valid
  end
end
