module Sellers::Applications
  class StepPresenter
    attr_reader :contract_class

    def initialize(contract_class)
      @contract_class ||= contract_class
    end

    def ==(other)
      contract_class == other.contract_class
    end

    def name(type = :short)
      I18n.t("#{i18n_base}.#{type}", default: I18n.t("#{i18n_base}.short"))
    end

    def button_label(default:)
      I18n.t("#{i18n_key}.steps.#{key}.button_label", default: default)
    end

    def i18n_key
      'sellers.applications'
    end

    def i18n_base
      "#{i18n_key}.steps.#{key}"
    end

    def key
      contract_class.name.demodulize.sub(/Form$/, '').underscore
    end

    def slug
      key.dasherize
    end

    def path(application:)
      Rails.application.routes.url_helpers.send(
        :sellers_application_step_path, id: application.id, step: slug
      )
    end

    def complete?(version, validate_optional_steps: false)
      contract = build_contract(version)

      if validate_optional_steps
        contract.valid?
      else
        contract.started? && contract.valid?
      end
    end

    def started?(version)
      build_contract(version).started?
    end

    private

    def build_contract(version)
      contract_class.new(version)
    end
  end
end
