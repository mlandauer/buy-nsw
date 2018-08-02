class Admin::InviteWaitingSellers < ApplicationService
  extend Forwardable

  def_delegators :build_operation, :waiting_sellers, :invalid_waiting_sellers

  def initialize(waiting_seller_ids:)
    @waiting_seller_ids = waiting_seller_ids
  end

  def call
    begin
      raise Failure unless build_operation.success?

      waiting_sellers.each do |seller|
        ActiveRecord::Base.transaction do
          update_seller_attributes(seller)
          send_invitation_email(seller)
        end
      end

      self.state = :success
    rescue Failure
      self.state = :failure
    end
  end

private
  attr_reader :waiting_seller_ids

  def build_operation
    @build_operation ||= Admin::BuildInviteWaitingSellers.call(
      waiting_seller_ids: waiting_seller_ids
    )
  end

  def update_seller_attributes(seller)
    seller.invitation_token = SecureRandom.hex(24)
    seller.invited_at = Time.now
    seller.mark_as_invited
    raise Failure unless seller.save
  end

  def send_invitation_email(seller)
    mailer = WaitingSellerMailer.with(waiting_seller: seller.reload)
    mailer.invitation_email.deliver_later
  end

end
