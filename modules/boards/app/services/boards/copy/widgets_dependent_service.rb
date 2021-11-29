#-- encoding: UTF-8



module Boards::Copy
  class WidgetsDependentService < ::Grids::Copy::WidgetsDependentService
    protected

    def duplicate_widget(widget, _new_board, _params)
      unless widget.identifier == 'work_package_query'
        raise "Expected widget work_package_query, got #{widget.identifier}"
      end

      super
    end
  end
end
