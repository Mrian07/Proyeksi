#-- encoding: UTF-8



module Bim::Bcf::API::V2_1::Endpoints
  class Index < API::Utilities::Endpoints::Index
    def mount
      index = self

      -> do
        index.render(self)
      end
    end

    def render(request)
      collection = scope ? request.instance_exec(&scope) : model

      collection
        .map do |instance|
        render_representer
          .new(instance)
      end
    end

    private

    def deduce_render_representer
      "::Bim::Bcf::API::V2_1::#{deduce_api_namespace}::SingleRepresenter".constantize
    end
  end
end
