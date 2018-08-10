class Admin::RevertSellerVersion < ApplicationService
  def initialize(seller_version_id:, current_user:)
    @seller_version_id = seller_version_id
    @current_user = current_user
  end

  def seller_version
    @seller_version ||= SellerVersion.find(seller_version_id)
  end

  def call
    begin
      ActiveRecord::Base.transaction do
        validate_current_user
        validate_state
        update_version_state
        update_product_states
        persist_version
        log_event
      end

      self.state = :success
    rescue Failure
      self.state = :failure
    end
  end

private
  attr_reader :seller_version_id, :current_user

  def products
    seller_version.seller.products
  end

  def validate_current_user
    unless current_user.present? && seller_version.assigned_to == current_user
      raise Failure
    end
  end

  def validate_state
    unless seller_version.approved? && seller_version.may_return_to_applicant?
      raise Failure
    end
  end

  def update_version_state
    seller_version.return_to_applicant
  end

  def update_product_states
    products.active.each(&:make_inactive!)
  end

  def persist_version
    raise Failure unless seller_version.save
  end

  def log_event
    Event::RevertedApplication.create(
      user: current_user,
      eventable: seller_version,
    )
  end
end
