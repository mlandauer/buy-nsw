module Search::Admin
  class SellerVersion < Search::Base
    def available_filters
      {
        assigned_to: assigned_to_keys,
        state: state_keys,
        name: :term_filter,
        email: :term_filter,
        business_identifiers: [:disability, :indigenous, :not_for_profit, :regional, :start_up, :sme],
        checkbox_filters: [:reverted],
        sort: sort_keys,
      }
    end

    private

    include Concerns::Search::ApplicationFilters
    include Concerns::Search::SellerTagFilters

    def base_relation
      ::SellerVersion.where("state != 'archived'")
    end

    def state_keys
      ::SellerVersion.aasm.states.map(&:name)
    end

    def assigned_to_keys
      ::User.admin.map do |user|
        [user.email, user.id]
      end
    end

    def apply_filters(scope)
      scope.yield_self(&method(:state_filter)).
        yield_self(&method(:assigned_to_filter)).
        yield_self(&method(:sort_filter)).
        yield_self(&method(:name_filter)).
        yield_self(&method(:email_filter)).
        yield_self(&method(:start_up_filter)).
        yield_self(&method(:sme_filter)).
        yield_self(&method(:disability_filter)).
        yield_self(&method(:regional_filter)).
        yield_self(&method(:indigenous_filter)).
        yield_self(&method(:not_for_profit_filter)).
        yield_self(&method(:reverted_filter))
    end

    def name_filter(relation)
      if filter_selected?(:name)
        term = filter_value(:name)
        relation.basic_search(name: term)
      else
        relation
      end
    end

    def email_filter(relation)
      if filter_selected?(:email)
        term = filter_value(:email)
        relation.joins(:owners).basic_search(users: { email: term })
      else
        relation
      end
    end

    def reverted_filter(relation)
      if filter_selected?(:checkbox_filters, :reverted)
        relation.assigned.created
      else
        relation
      end
    end
  end
end
