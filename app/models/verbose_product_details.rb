class VerboseProductDetails < ProductDetails
  # rubocop:disable Metrics/LineLength
  private

  def product_basics
    attributes do |a|
      a["Tell us the name of your product"] = product.name
      a["Which product category best describes your product"] = product.section_text
      a["Tell us briefly about hte need it address"] = product.summary
      a["Select up to 3 groups of buyers who would be most interested in your product"] = product.audiences.texts
      a["Features"] = product.features
      a["Benefits"] = product.benefits

      a["Is this product your own, or are you reselling"] = product.reseller_type_text

      unless product.reseller_type == 'own-product'
        a["Organisation resold"] = product.organisation_resold
      end

      a["If potential buyers have questions, who should they contact"] = product.custom_contact

      if product.custom_contact
        a["Product contact name"] = product.contact_name
        a["Product contact email"] = product.contact_email
        a["Product contact phone"] = product.contact_phone
      end
    end
  end

  def additional_terms
    {
      'Additional terms document' => (product.terms.present? ? product.terms : 'Not provided'),
    }
  end

  def commercials
    attributes do |a|
      a["Is this product available as freeware"] = product.free_version

      if product.free_version
        a["Describe the free version of your product"] = product.free_version_details
      end

      a["Do you provide a free trial option for your product"] = product.free_trial

      if product.free_trial
        a["Provide a link to the free trial for your product"] = product.free_trial_url
      end

      a["Minimum price"] = product.pricing_min
      a["Maximum price"] = product.pricing_max
      a["Currency"] = product.pricing_currency

      if product.pricing_currency == 'other'
        a["Specify the currency with its international standard 3 letter code, eg. AUD, USD or HKD"] = product.pricing_currency_other
      end

      a["Unit of pricing"] = product.pricing_unit
      a["Which variables affect your pricing"] = product.pricing_variables
      a["Link to your pricing calculator (optional)"] = product.pricing_calculator_url

      a["Do you offer special pricing for educational organisations"] = product.education_pricing

      if product.education_pricing
        a["Who is eligible"] = product.education_pricing_eligibility
        a["How does the pricing differ"] = product.education_pricing_differences
      end

      a["Do you offer special pricing for not-for-profit organisations"] = product.not_for_profit_pricing

      if product.not_for_profit_pricing
        a["Who is eligible"] = product.not_for_profit_pricing_eligibility
        a["How does the pricing differ"] = product.not_for_profit_pricing_differences
      end
    end
  end

  def onboarding_and_offboarding
    {
      "How do you help buyers get started with your product" => product.onboarding_assistance,
      "What assistance do you provide when a buyer no longer needs your product" => product.offboarding_assistance,
    }
  end

  def environment
    attributes do |a|
      a["How is the product deployed"] = product.deployment_model.texts
      if product.deployment_model.include?('other-cloud')
        a["Specify the other cloud model"] = product.deployment_model_other
      end

      a["Is the product an add-on or extension to other software services"] = product.addon_extension_type_text

      if ['yes', 'yes-and-standalone'].include?(product.addon_extension_type)
        a["Specify the software service"] = product.addon_extension_details
      end

      a["Is there an API for your product"] = product.api

      if ['rest', 'non-rest'].include?(product.api)
        a["If yes then describe what users can do using your API"] = product.api_capabilities
        a["If yes then describe what automation tools work with your product's API"] = product.api_automation
      end

      a["Is your product connected to a government network"] = product.government_network_type.texts

      if product.government_network_type.include?('other')
        a["If other specify the other government network"] = product.government_network_other
      end

      a["Is there a web browser interface for your product"] = product.web_interface

      if product.web_interface
        a["If yes then describe what users can do using your web browser interface"] = product.web_interface_details
        a["If yes which browsers are supported"] = product.supported_browsers.texts
      end

      a["Has your product been designed to work on mobile devices"] = product.mobile_devices

      if product.mobile_devices
        a["Describe any differences between the mobile and desktop functionality"] = product.mobile_desktop_differences
      end

      a["Do users need to download and install an application to use your product"] = product.installed_application
      if product.installed_application
        a["Which operating systems are supported"] = product.supported_os.texts

        if product.supported_os.include?('other')
          a["If other specify the other operating systems"] = product.supported_os_other
        end
      end

      a["What aspects of your product meet WCAG 2.0 AA or EN 301 549 standards"] = product.accessibility_type_text

      if product.accessibility_type == 'exclusions'
        a["If exclusions apply then specify exclusions"] = product.accessibility_exclusions
      end

      a["How does your product scale"] = product.scaling_type_text
    end
  end

  def availability_and_support
    {
      "What level of availability do you guarantee and how are buyers compensated if you don't meet this level" => product.guaranteed_availability,
      "Which support options are available" => product.support_options.texts,
      "Which options come at additional cost" => product.support_options_additional_cost,
      "Describe the support levels you provide, availability hours and whether there are additional costs involved" => product.support_levels,
    }
  end

  def locations
    attributes do |a|
      a["Can buyers choose where their data is stored, processed and managed"] = product.data_location_control
      a["Where is buyer data stored, processed and managed"] = product.data_location_text

      if product.data_location == 'other-known'
        a["If other then specify"] = product.data_location_other
      end
      if product.data_location == 'dont-know'
        a["If don't know then tell us why you don't know"] = product.data_location_unknown_reason
      end

      a["Do you operate your own data centres"] = product.own_data_centre
      if product.own_data_centre
        a["If yes then tell us about your data centres, including standards and certifications achieved"] = product.own_data_centre_details
      end

      a["Are there any third parties involved in storing, processing or managing buyer data"] = product.third_party_involved
      if product.third_party_involved
        a["If yes then list the third parties involved"] = product.third_party_involved_details
      end
    end
  end

  def user_data
    attributes do |a|
      a["Which data formats can be used to upload data"] = product.data_import_formats.texts

      if product.data_import_formats.include?('other')
        a["List the other formats for uploading data"] = product.data_import_formats_other
      end

      a["Which data formats can be used to export data"] = product.data_export_formats.texts

      if product.data_export_formats.include?('other')
        a["List the other formats for exporting data"] = product.data_export_formats_other
      end

      a["Are there any restrictions on users accessing or extracting data"] = product.data_access_restrictions

      if product.data_access_restrictions
        a["Specify, and note restrictions on accessing or extracting data may breach the agreement, and disqualify you as a seller"] = product.data_access_restrictions_details
      end

      a["Can users access audit information about activities and transactions performed using your product"] = product.audit_information
      a["What is the maximum time audit information data is stored"] = product.audit_storage_period
      a["What is the maximum time system logs are stored"] = product.log_storage_period

      a["How do you securely dispose of user data"] = product.data_disposal_approach
    end
  end

  def backup_and_recovery
    {
      "What is backed up" => product.backup_capability_text,
      "How often are backups performed" => product.backup_scheduling_type_text,
      "How do users recover backups" => product.backup_recovery_type_text,
    }
  end

  def data_protection
    attributes do |a|
      a["How do you protect data between the end user and your network"] = product.encryption_transit_user_types.texts

      if product.encryption_transit_user_types.include?('other')
        a["If other then specify"] = product.encryption_transit_user_other
      end

      a["How do you protect data within your network"] = product.encryption_transit_network_types.texts

      if product.encryption_transit_network_types.include?('other')
        a["If other then specify"] = product.encryption_transit_network_other
      end

      a["How do you protect data at rest"] = product.encryption_rest_types.texts

      if product.encryption_rest_types.include?('other')
        a["If other then specify"] = product.encryption_rest_other
      end

      a["If you are storing encrypted data, who controls encryption keys"] = product.encryption_keys_controller_text
    end
  end

  def identity_and_authentication
    attributes do |a|
      a["Do users need to be authenticated when using the product"] = product.authentication_required

      if product.authentication_required
        a["How do you authenticate users when they access the product"] = product.authentication_types.texts
        a["If other, describe how else you authenticate users"] = product.authentication_other
      end
    end
  end

  def security_standards
    attributes do |a|
      a["What standards does your data centre security setup comply with"] = product.data_centre_security_standards_text
      a["Do you have a current ISO/IEC 27001:2013 certification or later that covers the security of your product"] = product.iso_27001

      if product.iso_27001
        a["Who accredited the ISO/IEC 27001:2013 certification"] = product.iso_27001_accreditor
        a["When does the certification expire"] = product.iso_27001_date
        a["What's not covered by the certification"] = product.iso_27001_exclusions
      end

      a["Do you have a current ISO/IEC 27017:2015 certification (or later) that covers the security of your product"] = product.iso_27017

      if product.iso_27017
        a["Who accredited the ISO/IEC 27017:2015 certification"] = product.iso_27017_accreditor
        a["When does the certification expires"] = product.iso_27017_date
        a["What's not covered by the certification"] = product.iso_27017_exclusions
      end

      a["Do you have a current ISO/IEC 27018:2014 certification (or later) that covers the security of your product"] = product.iso_27018

      if product.iso_27018
        a["Who accredited the ISO/IEC 27018:2014 certification"] = product.iso_27018_accreditor
        a["When does the certification expire"] = product.iso_27018_date
        a["What's not covered by the certification"] = product.iso_27018_exclusions
      end

      a["Do you have a current CSA Security, Trust & Assurance Registry (STAR) certification that covers the security of your product"] = product.csa_star

      if product.csa_star
        a["Who accredited the CSA STAR certification"] = product.csa_star_accreditor
        a["When does the certification expire"] = product.csa_star_date
        a["What level is the certification"] = product.csa_star_level_text
        a["What's not covered by the certification"] = product.csa_star_exclusions
      end

      a["Do you have a current Payment Card Industry Data Security Standard (PCI DSS) certification that covers the security of your product"] = product.pci_dss

      if product.pci_dss
        a["Who accredited the PCI DSS certification"] = product.pci_dss_accreditor
        a["When does the certification expire"] = product.pci_dss_date
        a["What's not covered by your PCI DSS certification"] = product.pci_dss_exclusions
      end

      a["Do you have a current SOC II certification that covers the security of your product"] = product.soc_2

      if product.soc_2
        a["Who accredited the SOC II certification"] = product.soc_2_accreditor
        a["When does the certification expire"] = product.soc_2_date
        a["What's not covered by your SOC II certification"] = product.soc_2_exclusions
      end

      a["Are you Information Security Registered Assessors Program (IRAP) assessed"] = product.irap_type_text
      a["Is your cloud product certified by the Australian Signals Directorate (ASD)"] = product.asd_certified
      a["What data security classificiation is your cloud service certified to in Australia"] = product.security_classification_types.texts
      a["Include a link to further information about your security assessments (optional)"] = product.security_information_url
    end
  end

  def security_practices
    {
      "What practices does your organisation follow for secure software development" => product.secure_development_approach_text,
      "How often do you do penetration testing" => product.penetration_testing_frequency_text,
      "What's your approach to penetration testing" => product.penetration_testing_approach.texts,
    }
  end

  def user_separation
    attributes do |a|
      a["Do you rely on virtualisation technology to keep applications and users sharing the same infrastructure apart"] = product.virtualisation

      if product.virtualisation
        a["Who implements the virtualisation technology"] = product.virtualisation_implementor_text

        if product.virtualisation_implementor == 'third-party'
          a["Specify the third party"] = product.virtualisation_third_party
        end

        a["What virtualisation technologies are used"] = product.virtualisation_technologies.texts

        if product.virtualisation_technologies.include?('other')
          a["Specify other virtualisation technologies used"] = product.virtualisation_technologies_other
        end

        a["Describe how different organisations sharing the same infrastructure are kept apart"] = product.user_separation_details
      end
    end
  end

  def reporting_and_analytics
    attributes do |a|
      a["What metrics does your product report to users"] = product.metrics_contents
      a["How do you provide these reporting metrics to users"] = product.metrics_channel_types.texts

      if product.metrics_channel_types.include?('other')
        a["Specify how else you provide these reports"] = product.metrics_channel_other
      end

      a["How do you provide outage alerts to users"] = product.outage_channel_types.texts

      if product.outage_channel_types.include?('other')
        a["Specify how else you provide outage alerts"] = product.outage_channel_other
      end

      a["How are users notified when nearing service limits"] = product.usage_channel_types.texts

      if product.usage_channel_types.include?('other')
        a["Specify how else users are notified when nearing service limits"] = product.usage_channel_other
      end
    end
  end

  def operational_security
    {
      'Which configuration and change management processes does your organisation follow' => product.change_management_processes_text,
      'Describe your configuration and change management approach' => product.change_management_approach,
      'Which vulnerability management processes does your organisation follow' => product.vulnerability_processes_text,
      'Describe your vulnerability management process' => product.vulnerability_approach,
      'Which protective monitoring processes does your organisation follow' => product.protective_monitoring_processes_text,
      'Describe your protective monitoring process' => product.protective_monitoring_approach,
      'Which crisis and incident management processes does your organisation follow' => product.incident_management_processes_text,
      'Describe your crisis and incident management plan' => product.incident_management_approach,
      'How often do you test your access controls' => product.access_control_testing_frequency_text,
    }
  end
  # rubocop:enable Metrics/LineLength
end
