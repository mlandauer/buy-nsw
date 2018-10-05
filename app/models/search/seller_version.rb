module Search
  class SellerVersion < Base
    def initialize(args = {})
      term = args.delete(:term)

      if term.present?
        args[:selected_filters] ||= {}
        args[:selected_filters].merge!(term: term)
      end

      super(args)
    end

    def available_filters
      {
        term: :term_filter,
        services: service_keys,
        business_identifiers: [
          :disability, :indigenous, :not_for_profit, :regional, :start_up, :sme,
        ],
        govdc: [:govdc],
      }
    end

    def term
      filter_value(:term)
    end

    private

    include Concerns::Search::SellerTagFilters

    def base_relation
      ::SellerVersion.approved
    end

    def apply_filters(scope)
      scope.yield_self(&method(:term_filter)).
        yield_self(&method(:start_up_filter)).
        yield_self(&method(:sme_filter)).
        yield_self(&method(:disability_filter)).
        yield_self(&method(:regional_filter)).
        yield_self(&method(:indigenous_filter)).
        yield_self(&method(:not_for_profit_filter)).
        yield_self(&method(:services_filter)).
        yield_self(&method(:govdc_filter))
    end

    def term_filter(relation)
      if term.present?
        relation.basic_search(term)
      else
        relation
      end
    end

    def services_filter(relation)
      relation
      service_keys.each do |service|
        if filter_selected?(:services, service)
          relation = relation.with_service(service)
        end
      end
      relation
    end

    def service_keys
      ::SellerVersion.services.values
    end
  end
end
