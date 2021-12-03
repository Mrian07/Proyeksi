#-- encoding: UTF-8

module WorkPackages::Scopes::IncludeDerivedDates
  extend ActiveSupport::Concern

  class_methods do
    def include_derived_dates
      left_joins(:descendants)
        .select(*select_statement)
        .group(:id)
    end

    private

    def select_statement
      ["LEAST(MIN(#{descendants_alias}.start_date), MIN(#{descendants_alias}.due_date)) AS derived_start_date",
       "GREATEST(MAX(#{descendants_alias}.start_date), MAX(#{descendants_alias}.due_date)) AS derived_due_date"]
    end

    def descendants_alias
      'descendants_work_packages'
    end
  end
end
