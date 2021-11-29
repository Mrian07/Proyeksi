#-- encoding: UTF-8



module Queries
  module Projects
    module Filters
      class AncestorFilter < ::Queries::Projects::Filters::ProjectFilter
        def scope
          case operator
          when '='
            Project.joins(join_specific_ancestor_projects.join_sources)
          when '!'
            Project.joins(left_join_ancestor_projects.join_sources)
                   .where(ancestor_not_in_values_condition)
          else
            raise "unsupported operator"
          end
        end

        def type
          :list
        end

        def self.key
          :ancestor
        end

        private

        def type_strategy
          # Instead of getting the IDs of all the projects a user is allowed
          # to see we only check that the value is an integer.  Non valid ids
          # will then simply create an empty result but will not cause any
          # harm.
          @type_strategy ||= ::Queries::Filters::Strategies::IntegerList.new(self)
        end

        def join_specific_ancestor_projects
          projects_table
            .join(projects_ancestor_table)
            .on(specific_ancestor_condition)
        end

        def left_join_ancestor_projects
          projects_table
            .outer_join(projects_ancestor_table)
            .on(ancestor_condition)
        end

        def specific_ancestor_condition
          ancestor_condition
            .and(ancestor_in_values_condition)
        end

        def ancestor_condition
          projects_table[:lft]
            .gt(projects_ancestor_table[:lft])
            .and(projects_table[:rgt].lt(projects_ancestor_table[:rgt]))
        end

        def ancestor_in_values_condition
          projects_ancestor_table[:id].in(values)
        end

        def ancestor_not_in_values_condition
          projects_ancestor_table[:id]
            .not_in(values)
            .or(projects_ancestor_table[:id].eq(nil))
        end

        def projects_table
          Project.arel_table
        end

        def projects_ancestor_table
          projects_table.alias(:ancestor_projects)
        end
      end
    end
  end
end
