#-- encoding: UTF-8



module Bim::Bcf::API::V2_1::Endpoints
  module ModifyMixin
    private

    def deduce_parse_service
      ::Bim::Bcf::API::V2_1::ParseResourceParamsService
    end

    def deduce_process_service
      "::Bim::Bcf::#{deduce_backend_namespace}::#{update_or_create}Service".constantize
    end

    def deduce_in_and_out_representer
      "::Bim::Bcf::API::V2_1::#{deduce_api_namespace}::SingleRepresenter".constantize
    end

    alias_method :deduce_parse_representer, :deduce_in_and_out_representer
    alias_method :deduce_render_representer, :deduce_in_and_out_representer
  end
end
