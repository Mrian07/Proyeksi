#-- encoding: UTF-8



module Grids
  class Widget < ActiveRecord::Base
    self.table_name = :grid_widgets

    belongs_to :grid
    serialize :options, Hash

    after_destroy :execute_after_destroy_strategy

    private

    def execute_after_destroy_strategy
      proc = Grids::Configuration.widget_strategy(grid.class, identifier).after_destroy

      instance_exec(&proc)
    end
  end
end
