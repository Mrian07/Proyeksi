#-- encoding: UTF-8



module WorkPackage::Ancestors
  extend ActiveSupport::Concern

  included do
    attr_accessor :work_package_ancestors

    ##
    # Retrieve stored eager loaded ancestors
    # or use awesome_nested_set#ancestors reduced by visibility
    def visible_ancestors(user)
      if work_package_ancestors.nil?
        self.class.aggregate_ancestors(id, user)[id]
      else
        work_package_ancestors
      end
    end
  end

  class_methods do
    def aggregate_ancestors(work_package_ids, user)
      ::WorkPackage::Ancestors::Aggregator.new(work_package_ids, user).results
    end
  end

  ##
  # Aggregate ancestor data for the given work package IDs.
  # Ancestors visible to the given user are returned, grouped by each input ID.
  class Aggregator
    attr_accessor :user, :ids

    def initialize(work_package_ids, user)
      @user = user
      @ids = work_package_ids
    end

    def results
      default = Hash.new do |hash, id|
        hash[id] = []
      end

      results = with_work_package_ancestors
                .map { |wp| [wp.id, wp.ancestors] }
                .to_h

      default.merge(results)
    end

    private

    def with_work_package_ancestors
      WorkPackage
        .where(id: @ids)
        .includes(:ancestors)
        .where(ancestors_work_packages: { project_id: Project.allowed_to(user, :view_work_packages) })
        .order(Arel.sql('relations.hierarchy DESC'))
    end
  end
end
