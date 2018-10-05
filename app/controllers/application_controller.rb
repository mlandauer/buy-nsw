class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate!

  class NotAuthorized < StandardError; end
  class NotFound < StandardError; end

  rescue_from NotAuthorized, with: :render_unauthorized
  rescue_from NotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  impersonates :user

  private

  def authenticate!
    if ENV['BASIC_USERNAME'].blank? || ENV['BASIC_PASSWORD'].blank?
      return
    end

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_USERNAME'] && password == ENV['BASIC_PASSWORD']
    end
  end

  def authorize_buyer!
    if !(current_user.buyer.present? && current_user.buyer.active?)
      raise NotAuthorized
    end
  end

  def render_not_found
    errors_controller.process(:not_found)
  end

  def render_unauthorized
    if current_user.present?
      flash.alert = 'You are not permitted to access this page.'
      redirect_to root_path
    else
      redirect_to new_user_session_path
    end
  end

  def errors_controller
    ErrorsController.new.tap do |controller|
      controller.request = request
      controller.response = response
    end
  end

  def csv_request?
    request.format.symbol == :csv
  end
end
