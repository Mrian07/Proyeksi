

module Versions
  class BaseContract < ::ModelContract
    include AssignableValuesContract

    def self.model
      Version
    end

    delegate :available_custom_fields,
             :new_record?,
             to: :model

    validate :user_allowed_to_manage
    validate :validate_project_is_set
    validate :validate_sharing_included

    attribute :name
    attribute :description
    attribute :start_date
    attribute :effective_date
    attribute :status
    attribute :sharing
    attribute :wiki_page_title do
      validate_page_title_in_wiki
    end

    def assignable_statuses
      Version::VERSION_STATUSES
    end

    # Returns the sharings that +user+ can set the version to
    def assignable_sharings
      Version::VERSION_SHARINGS.select do |s|
        if model.sharing_was == s
          true
        else
          case s
          when 'system'
            # Only admin users can set a systemwide sharing
            user.admin?
          when 'hierarchy', 'tree'
            # Only users allowed to manage versions of the root project can
            # set sharing to hierarchy or tree
            model.project.nil? || user.allowed_to?(:manage_versions, model.project.root)
          else
            true
          end
        end
      end
    end

    def assignable_wiki_pages
      wiki = model.project.wiki

      if wiki
        wiki.pages
      else
        WikiPage.where('1=0')
      end
    end

    def assignable_custom_field_values(custom_field)
      custom_field.possible_values
    end

    private

    def validate_sharing_included
      if model.sharing_changed? && !assignable_sharings.include?(model.sharing)
        errors.add :sharing, :inclusion
      end
    end

    def user_allowed_to_manage
      if model.project && !user.allowed_to?(:manage_versions, model.project)
        errors.add :base, :error_unauthorized
      end
    end

    def validate_project_is_set
      errors.add :project_id, :blank if model.project.nil?
    end

    def validate_page_title_in_wiki
      return unless model.wiki_page_title.present? && model.project&.wiki

      errors.add :wiki_page_title, :inclusion unless model.project.wiki.find_page(model.wiki_page_title)
    end
  end
end
