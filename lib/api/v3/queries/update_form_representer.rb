#-- encoding: UTF-8



module API
  module V3
    module Queries
      class UpdateFormRepresenter < FormRepresenter
        def form_url
          api_v3_paths.query_form(represented.id)
        end

        def resource_url
          api_v3_paths.query(represented.id)
        end

        def commit_action
          :update
        end

        def commit_method
          :patch
        end
      end
    end
  end
end
