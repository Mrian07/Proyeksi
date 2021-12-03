# Validates both the wiki page as well as its associated wiki content. The two are
# considered to be one outside of this contract.
module WikiPages
  class BaseContract < ::ModelContract
    attribute :wiki
    attribute :title
    attribute :slug
    attribute :parent
    attribute :text
    attribute :protected

    validate :validate_author_is_set
    validate :validate_wiki_is_set
    validate :validate_content_is_set
    validate :validate_user_edit_allowed
    validate :validate_user_protect_permission

    private

    def validate_user_edit_allowed
      if model.project && !user.allowed_to?(:edit_wiki_pages, model.project) ||
        (model.protected_was && !user.allowed_to?(:protect_wiki_pages, model.project))
        errors.add :base, :error_unauthorized
      end
    end

    def validate_author_is_set
      errors.add :author, :blank if model.content&.author.nil?
    end

    def validate_wiki_is_set
      errors.add :wiki, :blank if model.wiki.nil?
    end

    def validate_content_is_set
      errors.add :content, :blank if model.content.nil?
    end

    def validate_user_protect_permission
      if model.protected_changed? && !user.allowed_to?(:protect_wiki_pages, model.project)
        errors.add :protected, :error_unauthorized
      end
    end

    def changed_by_user
      content_changed = if model.content
                          model.content.respond_to?(:changed_by_user) ? model.content.changed_by_user : model.content.changed
                        else
                          []
                        end

      super + content_changed
    end
  end
end
