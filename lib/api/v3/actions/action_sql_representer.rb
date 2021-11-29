

module API
  module V3
    module Actions
      class ActionSqlRepresenter
        include API::Decorators::Sql::Hal

        property :_type,
                 representation: ->(*) { "'Action'" }

        property :id

        link :self,
             path: { api: :action, params: %w(action) },
             column: -> { :id },
             title: -> { nil }
      end
    end
  end
end
