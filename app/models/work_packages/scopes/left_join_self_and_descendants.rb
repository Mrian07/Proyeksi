#-- encoding: UTF-8

module WorkPackages::Scopes::LeftJoinSelfAndDescendants
  extend ActiveSupport::Concern

  class_methods do
    def left_join_self_and_descendants(user, work_package = nil)
      joins(join_descendants(user, work_package).join_sources)
    end

    private

    def join_descendants(user, work_package)
      wp_table
        .outer_join(relations_table)
        .on(relations_join_descendants_condition(work_package))
        .outer_join(wp_descendants)
        .on(hierarchy_and_allowed_condition(user))
    end

    def relations_from_and_type_matches_condition
      relations_join_condition = relation_of_wp_and_hierarchy_condition

      non_hierarchy_type_columns.each do |type|
        relations_join_condition = relations_join_condition.and(relations_table[type].eq(0))
      end

      relations_join_condition
    end

    def relation_of_wp_and_hierarchy_condition
      wp_table[:id].eq(relations_table[:from_id]).and(relations_table[:hierarchy].gteq(0))
    end

    def relations_join_descendants_condition(work_package)
      if work_package
        relations_from_and_type_matches_condition
          .and(wp_table[:id].eq(work_package.id))
      else
        relations_from_and_type_matches_condition
      end
    end

    def hierarchy_and_allowed_condition(user)
      self_or_descendant_condition
        .and(allowed_to_view_work_packages(user))
    end

    def allowed_to_view_work_packages(user)
      wp_descendants[:project_id].in(Project.allowed_to(user, :view_work_packages).select(:id).arel)
    end

    def self_or_descendant_condition
      relations_table[:to_id].eq(wp_descendants[:id])
    end

    def non_hierarchy_type_columns
      TypedDag::Configuration[WorkPackage].type_columns - [:hierarchy]
    end

    def wp_table
      @wp_table ||= WorkPackage.arel_table
    end

    def relations_table
      @relations || Relation.arel_table
    end

    def wp_descendants
      @wp_descendants ||= wp_table.alias('descendants')
    end
  end
end
