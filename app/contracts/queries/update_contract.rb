#-- encoding: UTF-8

require 'queries/base_contract'

module Queries
  class UpdateContract < BaseContract
    validate :user_allowed_to_change

    ##
    # Check if the current user may save the changes
    def user_allowed_to_change
      # Check user self-saving their own queries
      # or user saving public queries
      if model.is_public?
        user_allowed_to_change_public
      else
        user_allowed_to_change_query
      end
    end

    def user_allowed_to_change_query
      unless (model.user == user || model.user.nil?) && user_allowed_to_save_queries?
        errors.add :base, :error_unauthorized
      end
    end

    def user_allowed_to_change_public
      if may_not_manage_queries?
        errors.add :base, :error_unauthorized
      end
    end

    def user_allowed_to_edit_work_packages?
      user.allowed_to?(:edit_work_packages, model.project, global: model.project.nil?)
    end

    def user_allowed_to_save_queries?
      user.allowed_to?(:save_queries, model.project, global: model.project.nil?)
    end
  end
end
