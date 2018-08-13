module Products
  class OperationalSecurityForm < BaseForm
    property :change_management_processes
    property :change_management_approach
    property :vulnerability_processes
    property :vulnerability_approach
    property :protective_monitoring_processes
    property :protective_monitoring_approach
    property :incident_management_processes
    property :incident_management_approach
    property :access_control_testing_frequency

    validation :default, inherit: true do
      required(:change_management_processes).filled(in_list?: Product.change_management_processes.values)
      required(:change_management_approach).filled(:str?)
      required(:vulnerability_processes).filled(in_list?: Product.vulnerability_processes.values)
      required(:vulnerability_approach).filled(:str?)
      required(:protective_monitoring_processes).filled(in_list?: Product.protective_monitoring_processes.values)
      required(:protective_monitoring_approach).filled(:str?)
      required(:incident_management_processes).filled(in_list?: Product.incident_management_processes.values)
      required(:incident_management_approach).filled(:str?)
      required(:access_control_testing_frequency).filled(in_list?: Product.access_control_testing_frequency.values)
    end
  end
end
