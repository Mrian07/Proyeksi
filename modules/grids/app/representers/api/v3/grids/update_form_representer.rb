#-- encoding: UTF-8



module API
  module V3
    module Grids
      class UpdateFormRepresenter < FormRepresenter
        include API::Decorators::UpdateForm
      end
    end
  end
end
