class Ops::BuildInviteWaitingSellers < ApplicationService

  def initialize(waiting_seller_ids:)
    @waiting_seller_ids = waiting_seller_ids || []
  end

  def call
    if valid_waiting_sellers?
      self.state = :success
    else
      self.state = :failure
    end
  end

  def no_sellers_selected?
    waiting_sellers.empty?
  end

  def waiting_sellers
    @waiting_sellers ||= waiting_seller_ids.map {|id|
      WaitingSeller.created.find(id)
    }
  end

  def invalid_waiting_sellers
    @invalid_waiting_sellers ||= waiting_sellers.reject {|seller|
      form_class.new(seller).valid?
    }
  end

private
  attr_reader :waiting_seller_ids

  def form_class
    Admin::WaitingSeller::Contract::Update
  end

  def valid_waiting_sellers?
    waiting_sellers.any? && invalid_waiting_sellers.empty?
  end

end
