#-- encoding: UTF-8

module Grids
  ##
  # Base class for any grid-based model's copy service.
  class CopyService < ::BaseServices::Copy
    ##
    # DependentServices can be specialised through a class in the
    # concrete model's namespace, e.g. Boards::Copy::WidgetsDependentService.
    def self.copy_dependencies
      [
        widgets_dependency
      ]
    end

    def self.widgets_dependency
      module_parent::Copy::WidgetsDependentService
    rescue NameError
      Copy::WidgetsDependentService
    end

    def initialize(user:, source:, contract_class: ::EmptyContract)
      super user: user, source: source, contract_class: contract_class
    end

    protected

    def initialize_copy(source, params)
      grid = source.dup

      initialize_new_grid! grid, source, params

      ServiceResult.new success: grid.save, result: grid
    end

    def initialize_new_grid!(_new_grid, _original_grid, _params)
      ;
    end
  end
end
