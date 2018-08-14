class Buyers::UpdateApplication < ApplicationService
  extend Forwardable

  def_delegators :build_operation, :application, :form

  def initialize(user:, form_class:, attributes:)
    @user = user
    @form_class = form_class
    @attributes = attributes || {}
  end

  def call
    begin
      raise Failure unless build_operation.success?

      ActiveRecord::Base.transaction do
        assign_and_validate_attributes
        persist_form
      end

      self.state = :success
    rescue Failure
      self.state = :failure
    end
  end

private
  attr_reader :user, :form_class, :attributes

  def build_operation
    @build_operation ||= Buyers::BuildUpdateApplication.call(
      user: user,
      form_class: form_class,
    )
  end

  def assign_and_validate_attributes
    raise Failure unless form.validate(attributes)
  end

  def persist_form
    raise Failure unless form.save
  end
end
