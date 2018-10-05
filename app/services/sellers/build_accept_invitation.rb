class Sellers::BuildAcceptInvitation < ApplicationService
  def initialize(version_id:, confirmation_token:)
    @version_id = version_id
    @confirmation_token = confirmation_token
  end

  def call
    if version.present? && user.present?
      self.state = :success
    else
      self.state = :failure
    end
  end

  def version
    @version ||= SellerVersion.created.find_by_id(version_id)
  end

  def user
    @user ||= unconfirmed_users.find_by_confirmation_token(confirmation_token)
  end

  def form
    @form ||= Sellers::AcceptInvitationForm.new(user)
  end

  private

  attr_reader :version_id, :confirmation_token

  def unconfirmed_users
    version.seller.owners.unconfirmed
  end
end
