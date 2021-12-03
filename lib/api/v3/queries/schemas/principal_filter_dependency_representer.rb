#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class PrincipalFilterDependencyRepresenter <
          FilterDependencyRepresenter
          def href_callback
            query = CGI.escape(::JSON.dump(filter_query))

            # pageSize of 0 is the magic number for maximum size and not
            # the default pageSize value.
            "#{api_v3_paths.principals}?filters=#{query}&pageSize=0"
          end

          def type
            "[]User"
          end

          private

          def filter_query
            raise NotImplementedError, 'Subclasses need to implement #filter_query'
          end
        end
      end
    end
  end
end
