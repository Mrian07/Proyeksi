

require_relative 'base_representer'

module Bim::Bcf::API::V2_1::Viewpoints
  class ColoringRepresenter < BaseRepresenter
    protected

    def scope
      represented
        .select "jsonb_build_object('coloring', json_viewpoint #> '{components, coloring}') as json_viewpoint"
    end
  end
end
