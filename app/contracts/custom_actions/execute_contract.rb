#-- encoding: UTF-8



module CustomActions
  class ExecuteContract < BaseContract
    property :lock_version
    property :work_package_id

    validates :work_package_id, presence: true
    validate :work_package_visible

    private

    def work_package_visible
      return unless model.work_package_id

      unless WorkPackage.visible(user).where(id: model.work_package_id).exists?
        errors.add(:work_package_id, :does_not_exist)
      end
    end
  end
end
