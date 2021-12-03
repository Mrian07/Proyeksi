module Projects
  class ArchiveContract < ModelContract
    include RequiresAdminGuard
    include Projects::Archiver

    validate :validate_no_foreign_wp_references

    protected

    def validate_model?
      false
    end
  end
end
