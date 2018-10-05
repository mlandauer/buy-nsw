class BuyerApplicationFlow
  def initialize(application)
    @application = application
  end

  def steps
    [].tap do |steps|
      steps << BuyerApplications::BasicDetailsForm
      steps << BuyerApplications::EmailApprovalForm
      steps << BuyerApplications::EmploymentStatusForm

      if application.reload.requires_manager_approval?
        steps << BuyerApplications::ManagerApprovalForm
      end
    end
  end

  def valid?
    steps.map do |step|
      step.new(application)
    end.reject(&:valid?).empty?
  end

  private

  attr_reader :application
end
