class Admin::DecideSellerVersion < ApplicationService
  extend Forwardable

  def_delegators :build_operation, :seller_version, :form

  def initialize(seller_version_id:, current_user:, attributes:)
    @seller_version_id = seller_version_id
    @current_user = current_user
    @attributes = attributes
  end

  def call
    raise Failure unless build_operation.success?

    ActiveRecord::Base.transaction do
      assign_and_validate_attributes
      change_application_state
      set_timestamp
      persist_seller_version
      log_event
      notify_user_by_email
    end

    self.state = :success
  rescue Failure
    self.state = :failure
  end

  private

  attr_reader :seller_version_id, :current_user, :attributes

  def build_operation
    @build_operation ||= Admin::BuildDecideSellerVersion.call(
      seller_version_id: seller_version_id
    )
  end

  def assign_and_validate_attributes
    raise Failure unless form.validate(attributes)
  end

  def change_application_state
    case form.decision
    when 'approve' then seller_version.approve
    when 'reject' then seller_version.reject
    when 'return_to_applicant' then seller_version.return_to_applicant
    end
  end

  def set_timestamp
    seller_version.decided_at = Time.now
  end

  def persist_seller_version
    raise Failure unless form.save
  end

  def log_event
    params = {
      user: current_user,
      eventable: seller_version,
      note: form.response,
    }

    case form.decision
    when 'approve' then Event::ApprovedApplication.create(params)
    when 'reject' then Event::RejectedApplication.create(params)
    when 'return_to_applicant' then Event::ReturnedApplication.create(params)
    end
  end

  def notify_user_by_email
    mailer = SellerApplicationMailer.with(application: seller_version)

    case form.decision
    when 'approve'
      mailer.application_approved_email.deliver_later
    when 'reject'
      mailer.application_rejected_email.deliver_later
    when 'return_to_applicant'
      mailer.application_return_to_applicant_email.deliver_later
    end
  end
end
