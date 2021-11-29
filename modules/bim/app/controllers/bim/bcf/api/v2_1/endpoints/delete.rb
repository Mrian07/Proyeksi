#-- encoding: UTF-8



module Bim::Bcf::API::V2_1::Endpoints
  class Delete < API::Utilities::Endpoints::Delete
    include ModifyMixin

    def render_success(call)
      render_representer
        .new(call.result)
    end

    private

    def render_representer
      "::Bim::Bcf::API::V2_1::#{deduce_api_namespace}::SingleRepresenter".constantize
    end

    def deduce_process_service
      "::Bim::Bcf::#{deduce_backend_namespace}::DeleteService".constantize
    end
  end
end
