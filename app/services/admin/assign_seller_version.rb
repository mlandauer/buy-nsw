class Admin::AssignSellerVersion < ApplicationService
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
      persist_seller_version
      log_event
    end

    self.state = :success
  rescue Failure
    self.state = :failure
  end

  private

  attr_reader :seller_version_id, :current_user, :attributes

  def build_operation
    @build_operation ||= Admin::BuildAssignSellerVersion.call(
      seller_version_id: seller_version_id
    )
  end

  def assign_and_validate_attributes
    raise Failure unless form.validate(attributes)
  end

  def change_application_state
    seller_version.assign if seller_version.may_assign?
  end

  def persist_seller_version
    raise Failure unless form.save
  end

  def log_event
    Event::AssignedApplication.create(
      user: current_user,
      eventable: seller_version,
      email: seller_version.assigned_to.email
    )
  end
end
