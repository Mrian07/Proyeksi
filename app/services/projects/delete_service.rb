#-- encoding: UTF-8



module Projects
  class DeleteService < ::BaseServices::Delete
    include Projects::Concerns::UpdateDemoData

    def call(*)
      super.tap do |service_call|
        notify(service_call.success?)
      end
    end

    private

    def before_perform(*)
      OpenProject::Notifications.send('project_deletion_imminent', project: @project_to_destroy)

      delete_all_members
      destroy_all_work_packages

      super
    end

    # Deletes all project's members
    def delete_all_members
      MemberRole
        .includes(:member)
        .where(members: { project_id: model.id })
        .delete_all

      Member.where(project_id: model.id).destroy_all
    end

    def destroy_all_work_packages
      model.work_packages.each do |wp|
        wp.reload
        wp.destroy
      rescue ActiveRecord::RecordNotFound
        # Everything fine, we wanted to delete it anyway
      end
    end

    def notify(success)
      if success
        ProjectMailer.delete_project_completed(model, user: user).deliver_now
      else
        ProjectMailer.delete_project_failed(model, user: user).deliver_now
      end
    end
  end
end
