class Admin::DeactivateBuyer < ApplicationService
  def initialize(buyer_application_id:)
    @buyer_application_id = buyer_application_id
  end

  def buyer_application
    @buyer_application ||= BuyerApplication.find(buyer_application_id)
  end

  def call
    if buyer_application.may_deactivate? && buyer_application.deactivate!
      self.state = :success
    else
      self.state = :failure
    end
  end

private
  attr_reader :buyer_application_id
end
