class Sellers::AcceptInvitation < ApplicationService
  extend Forwardable

  def_delegators :build_operation, :version, :user, :form

  def initialize(version_id:, confirmation_token:, user_attributes:)
    @version_id = version_id
    @confirmation_token = confirmation_token
    @user_attributes = user_attributes
  end

  def call
    raise Failure unless build_operation.success?

    set_password
    confirm_user
    persist_user

    self.state = :success
  rescue Failure
    self.state = :failure
  end

  private

  attr_reader :version_id, :confirmation_token, :user_attributes

  def build_operation
    @build_operation ||= Sellers::BuildAcceptInvitation.call(
      version_id: version_id,
      confirmation_token: confirmation_token,
    )
  end

  def set_password
    raise Failure unless form.validate(user_attributes)
  end

  def confirm_user
    form.model.confirmed_at = Time.now
  end

  def persist_user
    unless form.save
      set_devise_errors_on_form
      raise Failure
    end
  end

  def set_devise_errors_on_form
    form.model.errors.each do |key, error|
      form.errors.add(key, error)
    end
  end
end
