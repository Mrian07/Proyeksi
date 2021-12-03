#-- encoding: UTF-8

require 'model_contract'

module Queries
  class BaseContract < ::ModelContract
    attribute :name

    attribute :project_id
    attribute :hidden
    attribute :is_public # => public
    attribute :display_sums # => sums
    attribute :timeline_visible
    attribute :timeline_zoom_level
    attribute :timeline_labels
    attribute :highlighting_mode
    attribute :highlighted_attributes
    attribute :show_hierarchies
    attribute :display_representation

    attribute :column_names # => columns
    attribute :filters

    attribute :sort_criteria # => sortBy
    attribute :group_by # => groupBy

    attribute :ordered_work_packages # => manual sort

    def self.model
      Query
    end

    validate :validate_project
    validate :user_allowed_to_make_public

    def validate_project
      errors.add :project, :error_not_found if project_id.present? && !project_visible?
    end

    def project_visible?
      Project.visible(user).where(id: project_id).exists?
    end

    def may_not_manage_queries?
      !user.allowed_to?(:manage_public_queries, model.project, global: model.project.nil?)
    end

    def user_allowed_to_make_public
      # Add error only when changing public flag
      return unless model.is_public_changed?
      return if model.project_id.present? && model.project.nil?

      if is_public && may_not_manage_queries?
        errors.add :public, :error_unauthorized
      end
    end
  end
end
