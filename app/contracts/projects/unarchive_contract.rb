

module Projects
  class UnarchiveContract < ModelContract
    include RequiresAdminGuard
    include Projects::Archiver

    validate :validate_all_ancestors_active

    protected

    def validate_model?
      false
    end
  end
end
