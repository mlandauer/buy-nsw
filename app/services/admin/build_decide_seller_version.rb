class Admin::BuildDecideSellerVersion < ApplicationService
  def initialize(seller_version_id:)
    @seller_version_id = seller_version_id
  end

  def call
    if seller_version.present? && can_be_decided?
      self.state = :success
    else
      self.state = :failure
    end
  end

  def form
    @form ||= Admin::SellerVersion::Contract::Decide.new(seller_version)
  end

  def seller_version
    @seller_version ||= SellerVersion.find(seller_version_id)
  end

private
  attr_reader :seller_version_id

  def can_be_decided?
    seller_version.may_approve?
  end

end
