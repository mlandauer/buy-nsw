class Sellers::SellerVersion::Invitation::Create < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :application_model!
    step :build_user!
    step Contract::Build(constant: Sellers::CreateInvitationForm)

    def application_model!(options, params:, **)
      options[:application_model] = options['config.current_user'].seller_versions.find(params[:application_id])
    end

    def build_user!(options, **)
      options['model'] = User.new(
        seller: options[:application_model].seller,
        roles: ['seller'],
      )
    end
  end

  step Nested(Present)
  step Contract::Validate(key: :invitation)
  step :set_random_password!
  step :skip_automatic_confirmation_email!
  step Contract::Persist()
  failure :pass_devise_errors_to_contract!
  success :send_invitation_email!

  def pass_devise_errors_to_contract!(options, model:, **)
    model.errors.each do |key, error|
      options['contract.default'].errors.add(key, error)
    end
  end

  def set_random_password!(options, model:, **)
    model.password = model.password_confirmation = SecureRandom.hex(32)
  end

  def skip_automatic_confirmation_email!(options, model:, **)
    # NOTE: This is a Devise method which, when called before save, skips
    # sending a confirmation email. It does, however, continue to set the
    # confirmation token.
    #
    model.skip_confirmation_notification!
  end

  def send_invitation_email!(options, model:, **)
    mailer = SellerInvitationMailer.with(version: options[:application_model], user: model)
    mailer.seller_invitation_email.deliver_later
  end
end
