

module Grids
  class Query < ::Queries::BaseQuery
    def self.model
      Grids::Grid
    end

    ##
    # Returns the scope this query is filtered for, if any.
    def filter_scope
      scope_filter = filters.detect { |f| f.name.to_sym == :scope }
      scope_filter&.values&.first
    end

    def default_scope
      configs = ::Grids::Configuration.all

      or_scope = configs.pop.visible(User.current)

      while configs.any?
        or_scope = or_scope.or(configs.pop.visible(User.current))
      end

      # Have to use the subselect as AR will otherwise remove
      # associations not defined on the subclass
      Grids::Grid.where(id: or_scope)
    end
  end
end
