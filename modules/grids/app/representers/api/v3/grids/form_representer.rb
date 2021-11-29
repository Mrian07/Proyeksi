#-- encoding: UTF-8



module API
  module V3
    module Grids
      class FormRepresenter < ::API::Decorators::SimpleForm
        def model
          ::Grids::Grid
        end
      end
    end
  end
end
