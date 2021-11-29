

module Bim::Bcf::API::V2_1
  class Viewpoints::BaseRepresenter < BaseRepresenter
    def to_json(*_args)
      row = scope.first
      raise ::ActiveRecord::RecordNotFound unless row

      # If we access row.json, Rails is going to cast the json to ruby hash for us
      row.raw_json_viewpoint
    end

    protected

    def scope
      raise NotImplementedError
    end
  end
end
