module Versions
  class DeleteContract < ::DeleteContract
    delete_permission :manage_versions

    validate :validate_no_work_packages_attached

    protected

    def validate_no_work_packages_attached
      return unless model.work_packages.exists?

      errors.add(:base, :undeletable_work_packages_attached)
    end
  end
end
