#-- encoding: UTF-8



module Grids
  module Filters
    class GridFilter < Queries::Filters::Base
      self.model = ::Grids::Grid

      def human_name
        Grids::Grid.human_attribute_name(name)
      end
    end
  end
end
