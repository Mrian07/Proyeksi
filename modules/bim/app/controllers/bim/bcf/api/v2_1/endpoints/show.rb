#-- encoding: UTF-8



module Bim::Bcf::API::V2_1::Endpoints
  class Show < API::Utilities::Endpoints::Show
    def render(request)
      render_representer
        .new(request.instance_exec(request.params, &instance_generator))
    end

    private

    def deduce_render_representer
      "::Bim::Bcf::API::V2_1::#{deduce_api_namespace}::SingleRepresenter".constantize
    end
  end
end
