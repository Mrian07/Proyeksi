

module API
  module V3
    module Utilities
      module Endpoints
        module V3PresentSingle
          def present_success(request, call)
            render_representer
              .create(call.result,
                      current_user: request.current_user,
                      embed_links: true)
          end
        end
      end
    end
  end
end
