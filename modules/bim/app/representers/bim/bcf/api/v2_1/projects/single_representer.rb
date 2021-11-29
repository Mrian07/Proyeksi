#-- encoding: UTF-8



module Bim::Bcf::API::V2_1
  class Projects::SingleRepresenter < BaseRepresenter
    property :id,
             as: :project_id

    property :name
  end
end
