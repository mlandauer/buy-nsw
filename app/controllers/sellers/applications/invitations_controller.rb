class Sellers::Applications::InvitationsController < Sellers::Applications::BaseController
  skip_before_action :authenticate_user!, only: [:accept, :update_accept]

  def new
    @operation = run Sellers::SellerVersion::Invitation::Create::Present

    if params[:email].present?
      operation['contract.default'].email = params[:email]
    end
  end

  def create
    @operation = run Sellers::SellerVersion::Invitation::Create do |result|
      flash.notice = I18n.t(
        'sellers.applications.messages.invitation_sent', email: result['model'].email
      )
      return redirect_to sellers_application_path(result[:application_model])
    end

    render :new
  end

  def accept
    @operation = Sellers::BuildAcceptInvitation.call(
      version_id: params[:application_id],
      confirmation_token: params[:confirmation_token],
    )

    if operation.failure?
      flash.alert = I18n.t('sellers.applications.messages.invitation_invalid')
      redirect_to root_path
    end
  end

  def update_accept
    @operation = Sellers::AcceptInvitation.call(
      version_id: params[:application_id],
      confirmation_token: params[:confirmation_token],
      user_attributes: params[:user],
    )

    if operation.success?
      sign_in(operation.user)

      flash.notice = I18n.t('sellers.applications.messages.invitation_accepted')
      return redirect_to sellers_application_path(operation.version)
    end

    render :accept
  end

  private

  attr_reader :operation
  helper_method :operation

  def form
    if operation.is_a?(Sellers::AcceptInvitation) || operation.is_a?(Sellers::BuildAcceptInvitation)
      operation.form
    else
      operation['contract.default']
    end
  end
  helper_method :form

  def application
    @application ||= current_user.seller_versions.created.find(params[:application_id])
  end

  def owners
    application.owners
  end
  helper_method :owners
end
