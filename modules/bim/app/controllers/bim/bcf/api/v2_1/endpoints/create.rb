#-- encoding: UTF-8



module Bim::Bcf::API::V2_1::Endpoints
  class Create < API::Utilities::Endpoints::Create
    include ModifyMixin

    def present_success(_request, call)
      render_representer
        .new(call.result)
    end

    def postprocess_errors(call)
      ::Bim::Bcf::API::V2_1::Errors::ErrorMapper.map(super)
    end
  end
end
