module Products
  class SecurityStandardsForm < BaseForm
    feature Reform::Form::ActiveModel::FormBuilderMethods
    feature Reform::Form::MultiParameterAttributes

    property :data_centre_security_standards

    property :iso_27001
    property :iso_27001_accreditor
    property :iso_27001_date, multi_params: true
    property :iso_27001_exclusions

    property :iso_27017
    property :iso_27017_accreditor
    property :iso_27017_date, multi_params: true
    property :iso_27017_exclusions

    property :iso_27018
    property :iso_27018_accreditor
    property :iso_27018_date, multi_params: true
    property :iso_27018_exclusions

    property :csa_star
    property :csa_star_accreditor
    property :csa_star_date, multi_params: true
    property :csa_star_level
    property :csa_star_exclusions

    property :pci_dss
    property :pci_dss_accreditor
    property :pci_dss_date, multi_params: true
    property :pci_dss_exclusions

    property :soc_2
    property :soc_2_accreditor
    property :soc_2_date, multi_params: true
    property :soc_2_exclusions

    property :irap_type
    property :asd_certified
    property :security_classification_types
    property :security_information_url

    validation :default, inherit: true do
      required(:data_centre_security_standards).
        filled(in_list?: Product.data_centre_security_standards.values)

      required(:iso_27001).filled(:bool?)
      required(:iso_27001_accreditor).maybe(:str?)
      required(:iso_27001_date).maybe(:date?)
      required(:iso_27001_exclusions).maybe(:str?, max_word_count?: 200)

      rule(iso_27001_accreditor: [:iso_27001, :iso_27001_accreditor]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(iso_27001_date: [:iso_27001, :iso_27001_date]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(iso_27001_exclusions: [:iso_27001, :iso_27001_exclusions]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:iso_27017).filled(:bool?)
      required(:iso_27017_accreditor).maybe(:str?)
      required(:iso_27017_date).maybe(:date?)
      required(:iso_27017_exclusions).maybe(:str?, max_word_count?: 200)

      rule(iso_27017_accreditor: [:iso_27017, :iso_27017_accreditor]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(iso_27017_date: [:iso_27017, :iso_27017_date]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(iso_27017_exclusions: [:iso_27017, :iso_27017_exclusions]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:iso_27018).filled(:bool?)
      required(:iso_27018_accreditor).maybe(:str?)
      required(:iso_27018_date).maybe(:date?)
      required(:iso_27018_exclusions).maybe(:str?, max_word_count?: 200)

      rule(iso_27018_accreditor: [:iso_27018, :iso_27018_accreditor]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(iso_27018_date: [:iso_27018, :iso_27018_date]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(iso_27018_exclusions: [:iso_27018, :iso_27018_exclusions]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:csa_star).filled(:bool?)
      required(:csa_star_accreditor).maybe(:str?)
      required(:csa_star_date).maybe(:date?)
      required(:csa_star_level).maybe(in_list?: Product.csa_star_level.values)
      required(:csa_star_exclusions).maybe(:str?, max_word_count?: 200)

      rule(csa_star_accreditor: [:csa_star, :csa_star_accreditor]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(csa_star_date: [:csa_star, :csa_star_date]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(csa_star_level: [:csa_star, :csa_star_level]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(csa_star_exclusions: [:csa_star, :csa_star_exclusions]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:pci_dss).filled(:bool?)
      required(:pci_dss_accreditor).maybe(:str?)
      required(:pci_dss_date).maybe(:date?)
      required(:pci_dss_exclusions).maybe(:str?, max_word_count?: 200)

      rule(pci_dss_accreditor: [:pci_dss, :pci_dss_accreditor]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(pci_dss_date: [:pci_dss, :pci_dss_date]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(pci_dss_exclusions: [:pci_dss, :pci_dss_exclusions]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:soc_2).filled(:bool?)
      required(:soc_2_accreditor).maybe(:str?)
      required(:soc_2_date).maybe(:date?)
      required(:soc_2_exclusions).maybe(:str?, max_word_count?: 200)

      rule(soc_2_accreditor: [:soc_2, :soc_2_accreditor]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(soc_2_date: [:soc_2, :soc_2_date]) do |radio, field|
        radio.true?.then(field.filled?)
      end
      rule(soc_2_exclusions: [:soc_2, :soc_2_exclusions]) do |radio, field|
        radio.true?.then(field.filled?)
      end

      required(:irap_type).filled(:str?, in_list?: Product.irap_type.values)
      required(:asd_certified).filled(:bool?)
      required(:security_classification_types).
        filled(one_of?: Product.security_classification_types.values)
      required(:security_information_url).maybe(:str?, :url?)
    end
  end
end
