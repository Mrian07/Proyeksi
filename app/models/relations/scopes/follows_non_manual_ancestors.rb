#-- encoding: UTF-8

module Relations::Scopes
  module FollowsNonManualAncestors
    extend ActiveSupport::Concern

    class_methods do
      # Returns all follows relationships of work package ancestors or work package unless
      # the ancestor or a work package between the ancestor and self is manually scheduled.
      def follows_non_manual_ancestors(work_package)
        ancestor_relations_non_manual = hierarchy_or_reflexive
                                          .where(to_id: work_package.id)
                                          .where.not(from_id: from_manual_ancestors(work_package).select(:from_id))

        where(from_id: ancestor_relations_non_manual.select(:from_id))
          .follows
      end

      private

      def from_manual_ancestors(work_package)
        manually_schedule_ancestors = work_package.ancestors.where(schedule_manually: true)

        hierarchy_or_reflexive
          .where(to_id: manually_schedule_ancestors.select(:id))
      end
    end
  end
end
