

require_relative 'base_representer'

module Bim::Bcf::API::V2_1::Viewpoints
  class SelectionRepresenter < BaseRepresenter
    protected

    def scope
      represented
        .select "jsonb_build_object('selection', json_viewpoint #> '{components, selection}') as json_viewpoint"
    end
  end
end
