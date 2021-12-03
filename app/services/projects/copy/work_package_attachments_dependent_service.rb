#-- encoding: UTF-8

module Projects::Copy
  class WorkPackageAttachmentsDependentService < Dependency
    include ::Copy::Concerns::CopyAttachments

    def self.human_name
      I18n.t(:label_work_package_attachments)
    end

    def source_count
      source.work_packages.joins(:attachments).count('attachments.id')
    end

    protected

    def copy_dependency(params:)
      # If no work packages were copied, we cannot copy their attachments
      return unless state.work_package_id_lookup

      state.work_package_id_lookup.each do |old_wp_id, new_wp_id|
        copy_attachments('WorkPackage', from_id: old_wp_id, to_id: new_wp_id)
      end
    end
  end
end
