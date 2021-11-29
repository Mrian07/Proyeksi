#-- encoding: UTF-8



module Principals::Scopes
  module PossibleMember
    extend ActiveSupport::Concern

    class_methods do
      # Returns principals eligible to become project members. Those principals can be of class
      # * User
      # * PlaceholderUser
      # * Group
      # User instances need to be non locked (status)
      # Principals which already are project members are are returned.
      # @project [Project] The project for which eligible candidates are to be searched
      # @return [ActiveRecord::Relation] A scope of eligible candidates
      def possible_member(project)
        Queries::Principals::PrincipalQuery
          .new(user: ::User.current)
          .where(:member, '!', [project.id])
          .where(:status, '!', [statuses[:locked]])
          .results
      end
    end
  end
end
