class ProductDetails

  def initialize(product, include_all: false)
    @product = product
    @include_all = include_all
  end

  def details
    if include_all
      sections
    else
      sections.tap {|sections|
        # Filter out empty fields from the list – eg. conditional fields
        #
        sections.each {|key, fields|
          fields.delete_if {|label, value|
            value.nil? || (value.is_a?(Array) && value.empty?)
          }
        }
      }
    end
  end

private
  attr_reader :product, :include_all

  def sections
    include_all ? additional_sections.merge(core_sections) : core_sections
  end

  def core_sections
    {
      "Onboarding and offboarding" => onboarding_and_offboarding,
      "Availability and support" => availability_and_support,
      "Reporting and analytics" => reporting_and_analytics,
      "Identity and authentication" => identity_and_authentication,
      "Environment" => environment,
      "Locations" => locations,
      "User data" => user_data,
      "Backup and recovery" => backup_and_recovery,
      "Data protection" => data_protection,
      "Security standards" => security_standards,
      "Security practices" => security_practices,
      "Separation between users" => user_separation,
      "Operational security" => operational_security,
    }
  end

  def additional_sections
    {
      "Product basics" => product_basics,
      "Additional terms" => additional_terms,
      "Commercials" => commercials,
    }
  end

  def product_basics
    attributes do |a|
      a["Name"] = product.name
      a["Category"] = product.section_text
      a["Summary"] = product.summary
      a["Audiences"] = product.audiences.texts
      a["Features"] = product.features
      a["Benefits"] = product.benefits

      a["Reseller status"] = product.reseller_type_text

      unless product.reseller_type == 'own-product'
        a["Organisation resold"] = product.organisation_resold
      end

      a["Product-specific contact details"] = product.custom_contact

      if product.custom_contact
        a["Product contact name"] = product.contact_name
        a["Product contact email"] = product.contact_email
        a["Product contact phone"] = product.contact_phone
      end
    end
  end

  def additional_terms
    {
      'Additional terms document' => (product.terms.present? ? product.terms : 'Not provided')
    }
  end

  def commercials
    attributes do |a|
      a["Free version available"] = product.free_version

      if product.free_version
        a["Free version details"] = product.free_version_details
      end

      a["Free trial available"] = product.free_trial

      if product.free_trial
        a["Free trial URL"] = product.free_trial_url
      end

      a["Minimum price"] = product.pricing_min
      a["Maximum price"] = product.pricing_max
      a["Pricing currency"] = product.pricing_currency

      if product.pricing_currency == 'other'
        a["Other pricing currency"] = product.pricing_currency_other
      end

      a["Pricing unit"] = product.pricing_unit
      a["Variables affecting pricing"] = product.pricing_variables
      a["Pricing calculator URL"] = product.pricing_calculator_url

      a["Education pricing available"] = product.education_pricing

      if product.education_pricing
        a["Education pricing eligibility"] = product.education_pricing_eligibility
        a["Education pricing differences"] = product.education_pricing_differences
      end

      a["Not-for-profit pricing available"] = product.not_for_profit_pricing

      if product.not_for_profit_pricing
        a["Not-for-profit pricing eligibility"] = product.not_for_profit_pricing_eligibility
        a["Not-for-profit pricing differences"] = product.not_for_profit_pricing_differences
      end
    end
  end

  def onboarding_and_offboarding
    {
      "Onboarding assistance" => product.onboarding_assistance,
      "Offboarding assistance" => product.offboarding_assistance,
    }
  end

  def environment
    attributes do |a|
      a["Cloud deployment model"] = product.deployment_model.texts
      if product.deployment_model.include?('other-cloud')
        a["Other deployment model"] = product.deployment_model_other
      end

      a["Software add-on or extension"] = product.addon_extension_type_text

      if ['yes', 'yes-and-standalone'].include?(product.addon_extension_type)
        a["Add-on or extension to"] = product.addon_extension_details
      end

      a["API"] = product.api

      if ['rest','non-rest'].include?(product.api)
        a["What users can and can't do using the API"] = product.api_capabilities
        a["Compatible API automation tools"] = product.api_automation
      end

      a["Connected government networks"] = product.government_network_type.texts

      if product.government_network_type.include?('other')
        a["Other connected government networks"] = product.government_network_other
      end

      a["Web interface"] = product.web_interface

      if product.web_interface
        a["What users can and can't do using the web interface"] = product.web_interface_details
        a["Supported browsers"] = product.supported_browsers.texts
      end

      a["Application for users to install"] = product.installed_application

      if product.installed_application
        a["Supported operating systems"] = product.supported_os.texts

        if product.supported_os.include?('other')
          a["Other supported operating systems"] = product.supported_os_other
        end
      end

      a["Designed to work on mobile devices"] = product.mobile_devices

      if product.mobile_devices
        a["Differences in the mobile and desktop functionality"] = product.mobile_desktop_differences
      end

      a["Accessible to WCAG 2.0 AA or above"] = product.accessibility_type_text

      if product.accessibility_type == 'exclusions'
        a["Areas which are accessible (and exclusions)"] = product.accessibility_exclusions
      end

      a["How the product or service scales"] = product.scaling_type_text
    end
  end

  def availability_and_support
    {
      "Guaranteed availability (excluding scheduled outages)" => product.guaranteed_availability,
      "Support options available" => product.support_options.texts,
      "Which options come at additional cost" => product.support_options_additional_cost,
      "Support levels, availability hours (AEST) and whether additional costs are involved" => product.support_levels,
    }
  end

  def locations
    attributes do |a|
      a["Whether users can control where their data is stored, processed and managed in Australia"] = product.data_location_control
      a["Locations where user data is stored, processed and managed"] = product.data_location_text

      if product.data_location == 'other-known'
        a["Other known locations"] = product.data_location_other
      end
      if product.data_location == 'dont-know'
        a["Why the seller doesn't know"] = product.data_location_unknown_reason
      end

      a["Whether the seller operates their own data centres"] = product.own_data_centre
      if product.own_data_centre
        a["About the seller's data centre"] = product.own_data_centre_details
      end

      a["Whether third parties are involved in storing, processing or managing buyer data"] = product.third_party_involved
      if product.third_party_involved
        a["The third parties involved"] = product.third_party_involved_details
      end
    end
  end

  def user_data
    attributes do |a|
      a["Data import formats"] = product.data_import_formats.texts

      if product.data_import_formats.include?('other')
        a["Other data import formats"] = product.data_import_formats_other
      end

      a["Data export formats"] = product.data_export_formats.texts

      if product.data_export_formats.include?('other')
        a["Other data export formats"] = product.data_export_formats_other
      end

      a["Whether there are restrictions on users accessing or extracting data"] = product.data_access_restrictions

      if product.data_access_restrictions
        a["The restrictions on users accessing or extracting data"] = product.data_access_restrictions_details
      end

      a["Whether users can access audit information about activities and transactions"] = product.audit_information
      a["The maximum time audit information data is stored"] = product.audit_storage_period
      a["The maximum time system logs are stored"] = product.log_storage_period

      a["Approach to secure data disposal"] = product.data_disposal_approach
    end
  end

  def backup_and_recovery
    {
      "What is backed up" => product.backup_capability_text,
      "How often backups are performed" => product.backup_scheduling_type_text,
      "How users recover backups" => product.backup_recovery_type_text,
    }
  end

  def data_protection
    attributes do |a|
      a["Data protection between buyer and supplier networks"] = product.encryption_transit_user_types.texts

      if product.encryption_transit_user_types.include?('other')
        a["Other data protection between buyer and supplier networks"] = product.encryption_transit_user_other
      end

      a["Data protection within the supplier's network"] = product.encryption_transit_network_types.texts

      if product.encryption_transit_network_types.include?('other')
        a["Other data protection within the supplier's network"] = product.encryption_transit_network_other
      end

      a["Data protection at rest"] = product.encryption_rest_types.texts

      if product.encryption_rest_types.include?('other')
        a["Other data protection at rest"] = product.encryption_rest_other
      end

      a["Who controls encryption keys"] = product.encryption_keys_controller_text
    end
  end

  def identity_and_authentication
    attributes do |a|
      a["User authentication needed"] = product.authentication_required

      if product.authentication_required
        a["User authentication"] = product.authentication_types.texts
        a["Other user authentication"] = product.authentication_other
      end
    end
  end

  def security_standards
    attributes do |a|
      a["Data centre security standards"] = product.data_centre_security_standards_text
      a["ISO/IEC 27001:2013 certification"] = product.iso_27001

      if product.iso_27001
        a["Who accredited the ISO/IEC 27001:2013 certification"] = product.iso_27001_accreditor
        a["When the ISO/IEC 27001:2013 certification expires"] = product.iso_27001_date
        a["What the ISO/IEC 27001:2013 certification doesn't cover"] = product.iso_27001_exclusions
      end

      a["ISO/IEC 27017:2015 certification"] = product.iso_27017

      if product.iso_27017
        a["Who accredited the ISO/IEC 27017:2015 certification"] = product.iso_27017_accreditor
        a["When the ISO/IEC 27017:2015 certification expires"] = product.iso_27017_date
        a["What the ISO/IEC 27017:2015 certification doesn't cover"] = product.iso_27017_exclusions
      end

      a["ISO/IEC 27018:2014 certification"] = product.iso_27018

      if product.iso_27018
        a["Who accredited the ISO/IEC 27018:2014 certification"] = product.iso_27018_accreditor
        a["When the ISO/IEC 27018:2014 certification expires"] = product.iso_27018_date
        a["What the ISO/IEC 27018:2014 certification doesn't cover"] = product.iso_27018_exclusions
      end

      a["CSA STAR certification"] = product.csa_star

      if product.csa_star
        a["Who accredited the CSA STAR certification"] = product.csa_star_accreditor
        a["When the CSA STAR certification expires"] = product.csa_star_date
        a["CSA STAR level"] = product.csa_star_level_text
        a["What the CSA STAR certification doesn't cover"] = product.csa_star_exclusions
      end

      a["PCI DSS certification"] = product.pci_dss

      if product.pci_dss
        a["Who accredited the PCI DSS certification"] = product.pci_dss_accreditor
        a["When the PCI DSS certification expires"] = product.pci_dss_date
        a["What the PCI DSS certification doesn't cover"] = product.pci_dss_exclusions
      end

      a["SOC II certification"] = product.soc_2

      if product.soc_2
        a["Who accredited the SOC II certification"] = product.soc_2_accreditor
        a["When the SOC II certification expires"] = product.soc_2_date
        a["What the SOC II certification doesn't cover"] = product.soc_2_exclusions
      end

      a["IRAP assessed"] = product.irap_type_text
      a["Certified by the Australian Signals Directorate (ASD)"] = product.asd_certified
      a["Australian data security classification certification"] = product.security_classification_types.texts
      a["Further information about security assessments"] = product.security_information_url
    end
  end

  def security_practices
    {
      "Approach to secure software development best practice" => product.secure_development_approach_text,
      "How often the supplier conducts penetration testing" => product.penetration_testing_frequency_text,
      "The supplier's approach to penetration testing" => product.penetration_testing_approach.texts,
    }
  end

  def user_separation
    attributes do |a|
      a["Virtualisation used to keep users sharing the same infrastructure apart"] = product.virtualisation

      if product.virtualisation
        a["Who implements the virtualisation technology"] = product.virtualisation_implementor_text

        if product.virtualisation_implementor == 'third-party'
          a["Third party providing virtualisation"] = product.virtualisation_third_party
        end

        a["Technologies used to provide virtualisation"] = product.virtualisation_technologies.texts

        if product.virtualisation_technologies.include?('other')
          a["Other technologies used to provide virtualisation"] = product.virtualisation_technologies_other
        end

        a["Approach to separating different organisations on the same infrastructure"] = product.user_separation_details
      end
    end
  end

  def reporting_and_analytics
    attributes do |a|
      a["Metrics reported"] = product.metrics_contents
      a["Reporting types"] = product.metrics_channel_types.texts

      if product.metrics_channel_types.include?('other')
        a["Other reporting types"] = product.metrics_channel_other
      end

      a["Outage reporting"] = product.outage_channel_types.texts

      if product.outage_channel_types.include?('other')
        a["Other outage reporting"] = product.outage_channel_other
      end

      a["Usage reporting"] = product.usage_channel_types.texts

      if product.usage_channel_types.include?('other')
        a["Other usage reporting"] = product.usage_channel_other
      end
    end
  end

  def operational_security
    {
      'Configuration and change management processes' => product.change_management_processes_text,
      'Configuration and change management approach' => product.change_management_approach,
      'Vulnerability management processes' => product.vulnerability_processes_text,
      'Vulnerability management approach' => product.vulnerability_approach,
      'Protective monitoring processes' => product.protective_monitoring_processes_text,
      'Protective monitoring approach' => product.protective_monitoring_approach,
      'Crisis and incident management processes' => product.incident_management_processes_text,
      'Crisis and incident management plan' => product.incident_management_approach,
      'How often access controls are tested' => product.access_control_testing_frequency_text
    }
  end

  def attributes(&block)
    {}.tap(&block)
  end

end
