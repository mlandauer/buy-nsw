class Buyers::BuildUpdateApplication < ApplicationService
  def initialize(user:, form_class:)
    @user = user
    @form_class = form_class
  end

  def call
    if user.present? && application.present? && application.created?
      self.state = :success
    else
      self.state = :failure
    end
  end

  def application
    @application ||= user.buyer
  end

  def form
    @form ||= form_class.new(application)
  end

  private

  attr_reader :user, :form_class
end
