#-- encoding: UTF-8

module Queries::Copy
  class OrderedWorkPackagesDependentService < ::Copy::Dependency
    protected

    def copy_dependency(params:)
      return unless source.manually_sorted?

      duplicate_query_order(source, target)
    end

    def duplicate_query_order(query, new_query)
      query.ordered_work_packages.find_each do |ordered_wp|
        copied = ordered_wp.dup
        copied.query_id = new_query.id
        copied.work_package_id = lookup_work_package_id(ordered_wp.work_package_id)
        copied.save
      end
    end

    ##
    # Tries to lookup the work package id if
    # we're in a mapped condition (e.g., copying a project)
    def lookup_work_package_id(id)
      if state.work_package_id_lookup
        state.work_package_id_lookup[id] || id
      else
        id
      end
    end
  end
end
