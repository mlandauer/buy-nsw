class Admin::UpdateWaitingSeller < ApplicationService
  extend Forwardable

  def_delegators :build_operation, :waiting_seller, :form

  def initialize(waiting_seller_id:, attributes:)
    @waiting_seller_id = waiting_seller_id
    @attributes = attributes
  end

  def call
    raise Failure unless build_operation.success?

    ActiveRecord::Base.transaction do
      assign_and_validate_attributes
      persist_form
    end

    self.state = :success
  rescue Failure
    self.state = :failure
  end

  private

  attr_reader :waiting_seller_id, :attributes

  def build_operation
    @build_operation ||= Admin::BuildUpdateWaitingSeller.call(
      waiting_seller_id: waiting_seller_id,
      skip_prevalidate: true,
    )
  end

  def assign_and_validate_attributes
    raise Failure unless form.validate(attributes)
  end

  def persist_form
    raise Failure unless form.save
  end
end
