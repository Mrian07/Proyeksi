#-- encoding: UTF-8



module Queries
  class CopyService < ::BaseServices::Copy
    def self.copy_dependencies
      [
        ::Queries::Copy::MenuItemDependentService,
        ::Queries::Copy::OrderedWorkPackagesDependentService
      ]
    end

    protected

    def initialize_copy(source, _params)
      new_query = ::Query.new source.attributes.dup.except(*skipped_attributes)
      new_query.sort_criteria = source.sort_criteria if source.sort_criteria
      new_query.project = state.project || source.project

      ::Queries::Copy::FiltersMapper
        .new(state, new_query.filters)
        .map_filters!

      ServiceResult.new(success: new_query.save, result: new_query)
    end

    def skipped_attributes
      %w[id created_at updated_at project_id sort_criteria]
    end
  end
end
