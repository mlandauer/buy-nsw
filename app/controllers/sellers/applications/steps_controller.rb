class Sellers::Applications::StepsController < Sellers::Applications::BaseController
  layout '../sellers/applications/shared/_layout'

  def show
    @operation = run Sellers::SellerVersion::Update::Present
  end

  def update
    params[:seller_application] ||= {}

    @operation = run Sellers::SellerVersion::Update do |result|
      flash.notice = I18n.t('sellers.applications.messages.changes_saved')
      return redirect_to sellers_application_path(result['model.seller_version'])
    end

    render :show
  end

  def self.contracts(seller_version)
    base_contracts = [
      SellerVersions::BusinessDetailsForm,
      SellerVersions::AddressesForm,
      SellerVersions::CharacteristicsForm,
      SellerVersions::ContactsForm,
      SellerVersions::DisclosuresForm,
      SellerVersions::FinancialStatementForm,
      SellerVersions::ProductLiabilityForm,
      SellerVersions::ProfessionalIndemnityForm,
      SellerVersions::ProfileBasicsForm,
      SellerVersions::RecognitionForm,
      SellerVersions::ServicesForm,
      SellerVersions::WorkersCompensationForm,
    ]
    base_contracts.tap do |contracts|
      if seller_version.services.include?('cloud-services')
        contracts << SellerVersions::DeclarationForm
      end
    end
  end

  def self.steps(seller_version)
    contracts(seller_version).map do |contract|
      Sellers::Applications::StepPresenter.new(contract)
    end
  end

  private

  def _run_options(options)
    options.merge(
      'config.current_user' => current_user,
      'config.contract_class' => contract_class,
    )
  end

  def step
    self.class.steps(seller_version).find { |step| step.slug == params[:step] } || raise(NotFound)
  end
  helper_method :step

  def contract_class
    step.contract_class
  end

  attr_reader :operation
  helper_method :operation

  def seller
    operation['model.seller']
  end
  helper_method :seller

  def form
    operation["contract.default"]
  end
  helper_method :form

  def seller_version
    operation.present? ? operation['model.seller_version'] : super
  end
end
