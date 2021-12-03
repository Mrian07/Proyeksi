#-- encoding: UTF-8

#
module Query::ManualSorting
  extend ActiveSupport::Concern

  included do
    has_many :ordered_work_packages,
             -> { order(position: :asc) }

    def manually_sorted?
      sort_criteria_columns.any? { |clz, _| clz.is_a?(::Queries::WorkPackages::Columns::ManualSortingColumn) }
    end

    def self.manual_sorting_column
      ::Queries::WorkPackages::Columns::ManualSortingColumn.new
    end

    delegate :manual_sorting_column, to: :class
  end
end
