require 'rails_helper'

RSpec.describe SellerInvitationMailer, type: :mailer do

  describe '#seller_invitation_email' do
    let(:version) { create(:approved_seller_version) }
    let(:user) { create(:user, seller: version.seller) }

    let(:mail) { described_class.with(version: version, user: user).seller_invitation_email }

    it 'renders the headers' do
      expect(mail.subject).to match("You've been invited to work on a seller application")
      # TODO: Probably want the person's name in there too
      expect(mail.to).to contain_exactly(user.email)
    end

    it 'should include the name of the seller' do
      expect(mail.body.encoded).to match(version.name)
    end
  end
end
