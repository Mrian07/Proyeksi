#-- encoding: UTF-8



module Principals::Scopes
  module PossibleAssignee
    extend ActiveSupport::Concern

    class_methods do
      # Returns principals eligible to be assigned to a work package as:
      # * assignee
      # * responsible
      # Those principals can be of class
      # * User
      # * PlaceholderUser
      # * Group
      # User instances need to be non locked (status).
      # Only principals with a role marked as assignable in the project are returned.
      # @project [Project] The project for which eligible candidates are to be searched
      # @return [ActiveRecord::Relation] A scope of eligible candidates
      def possible_assignee(project)
        not_locked
          .includes(:members)
          .references(:members)
          .merge(Member.assignable.of(project))
      end
    end
  end
end
