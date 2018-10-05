module Search::Admin
  class User < Search::Base
    def available_filters
      {
        email: :term_filter,
      }
    end

    private

    def base_relation
      ::User.all
    end

    def apply_filters(scope)
      scope.yield_self(&method(:email_filter)).
        yield_self(&method(:sort_filter))
    end

    def sort_filter(relation)
      relation.order_by_id
    end

    def email_filter(relation)
      if filter_selected?(:email)
        term = filter_value(:email)
        relation.basic_search(email: term)
      else
        relation
      end
    end
  end
end
