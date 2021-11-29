

module Acts::Journalized
  module Permissions
    # Default implementation of journal editing permission
    # Is overridden if defined in the journalized model directly
    def journal_editable_by?(journal, user)
      return true if user.admin?

      editable = if respond_to? :editable_by?
                   editable_by?(user)
                 else
                   p = @project || (project if respond_to? :project)
                   options = { global: p.present? }
                   user.allowed_to? journable_edit_permission, p, options
                 end

      editable && journal.user_id == user.id
    end

    private

    def journable_edit_permission
      if respond_to? :journal_permission
        journal_permission
      else
        :"edit_#{self.class.to_s.pluralize.underscore}"
      end
    end
  end
end
