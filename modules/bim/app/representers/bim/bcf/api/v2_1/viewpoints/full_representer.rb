
require_relative 'base_representer'

module Bim::Bcf::API::V2_1::Viewpoints
  class FullRepresenter < BaseRepresenter
    def self.selector
      "json_viewpoint - 'components' as json_viewpoint"
    end

    protected

    def scope
      represented.select(self.class.selector)
    end
  end
end
