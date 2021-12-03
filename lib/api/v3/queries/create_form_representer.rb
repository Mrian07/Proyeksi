#-- encoding: UTF-8

module API
  module V3
    module Queries
      class CreateFormRepresenter < FormRepresenter
        def form_url
          api_v3_paths.create_query_form
        end

        def resource_url
          api_v3_paths.queries
        end

        def commit_action
          :create
        end

        def commit_method
          :post
        end
      end
    end
  end
end
