module Products
  class EnvironmentForm < BaseForm
    property :deployment_model
    property :deployment_model_other

    property :addon_extension_type
    property :addon_extension_details

    property :api
    property :api_capabilities
    property :api_automation

    property :government_network_type
    property :government_network_other

    property :web_interface
    property :web_interface_details
    property :supported_browsers

    property :installed_application
    property :supported_os
    property :supported_os_other

    property :mobile_devices
    property :mobile_desktop_differences

    property :accessibility_type
    property :accessibility_exclusions

    property :scaling_type

    validation :default, inherit: true do
      required(:deployment_model).filled(one_of?: Product.deployment_model.values)
      required(:deployment_model_other).maybe(:str?)

      rule(deployment_model_other: [:deployment_model, :deployment_model_other]) do |checkboxes, field|
        checkboxes.contains?('other-cloud').then(field.filled?)
      end

      required(:addon_extension_type).filled(in_list?: Product.addon_extension_type.values)
      required(:addon_extension_details).maybe(:str?)

      rule(addon_extension_details: [:addon_extension_type, :addon_extension_details]) do |radio, field|
        ( radio.eql?('yes') | radio.eql?('yes-and-standalone') ).then(field.filled?)
      end

      required(:api).filled(in_list?: Product.api.values)
      required(:api_capabilities).maybe(:str?)
      required(:api_automation).maybe(:str?)

      rule(api_capabilities: [:api, :api_capabilities]) do |radio, field|
        ( radio.eql?('rest') | radio.eql?('non-rest') ).then(field.filled?)
      end
      rule(api_automation: [:api, :api_automation]) do |radio, field|
        ( radio.eql?('rest') | radio.eql?('non-rest') ).then(field.filled?)
      end

      required(:government_network_type).filled(one_of?: Product.government_network_type.values)
      required(:government_network_other).maybe(:str?)

      rule(government_network_other: [:government_network_type, :government_network_other]) do |checkboxes, field|
        checkboxes.contains?('other').then(field.filled?)
      end

      required(:web_interface).filled(:bool?)
      required(:web_interface_details).maybe(:str?)
      optional(:supported_browsers).maybe(one_of?: Product.supported_browsers.values)

      rule(web_interface_details: [:web_interface, :web_interface_details]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(supported_browsers: [:web_interface, :supported_browsers]) do |radio, field|
        radio.true?.then(field.filled?.any_checked?)
      end

      required(:installed_application).filled(:bool?)
      optional(:supported_os).maybe(one_of?: Product.supported_os.values)
      required(:supported_os_other).maybe(:str?)

      rule(supported_os: [:installed_application, :supported_os]) do |radio, field|
        radio.true?.then(field.filled?.any_checked?)
      end
      rule(supported_os_other: [:installed_application, :supported_os, :supported_os_other]) do |radio, checkboxes, field|
        (radio.true? & checkboxes.contains?('other')).then(field.filled?)
      end

      required(:mobile_devices).filled(:bool?)
      required(:mobile_desktop_differences).maybe(:str?)

      rule(mobile_desktop_differences: [:mobile_devices, :mobile_desktop_differences]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:accessibility_type).filled(in_list?: Product.accessibility_type.values)
      required(:accessibility_exclusions).maybe(:str?)

      rule(accessibility_exclusions: [:accessibility_type, :accessibility_exclusions]) do |radio, field|
        radio.eql?('exclusions').then(field.filled?)
      end

      required(:scaling_type).filled(in_list?: Product.scaling_type.values)
    end
  end
end
