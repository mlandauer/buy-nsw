class Admin::BuildUpdateWaitingSeller < ApplicationService

  def initialize(waiting_seller_id:, skip_prevalidate: false)
    @waiting_seller_id = waiting_seller_id
    @skip_prevalidate = skip_prevalidate
  end

  def call
    if waiting_seller.present?
      prevalidate
      self.state = :success
    else
      self.state = :failure
    end
  end

  def waiting_seller
    @waiting_seller ||= WaitingSeller.created.find(waiting_seller_id)
  end

  def form
    @form ||= Admin::UpdateWaitingSellerForm.new(waiting_seller)
  end

private
  attr_reader :waiting_seller_id

  def skip_prevalidate?
    @skip_prevalidate == true
  end

  def prevalidate
    return if skip_prevalidate?
    form.validate(waiting_seller.attributes)
  end

end
