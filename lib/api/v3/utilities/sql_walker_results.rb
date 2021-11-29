#-- encoding: UTF-8



module API
  module V3
    module Utilities
      class SqlWalkerResults
        def initialize(scope, url_query:, self_path: nil, replace_map: {})
          self.scope = scope
          self.ctes = {}
          self.self_path = self_path
          self.url_query = url_query
          self.replace_map = replace_map
        end

        attr_accessor :scope,
                      :sql,
                      :selects,
                      :ctes,
                      :self_path,
                      :url_query,
                      :replace_map

        def page_size
          url_query[:pageSize]
        end

        def offset
          url_query[:offset]
        end
      end
    end
  end
end
