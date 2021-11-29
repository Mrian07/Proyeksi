#-- encoding: UTF-8



module Overviews
  class CopyService < ::Grids::CopyService
    protected

    def initialize_new_grid!(new_overview, _original_overview, _params)
      unless state.project
        raise ArgumentError, "Overviews can only be copied as part of a project. Each project may only contain 1 overview itself."
      end

      new_overview.project = state.project
    end
  end
end
