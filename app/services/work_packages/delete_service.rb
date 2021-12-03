#-- encoding: UTF-8

class WorkPackages::DeleteService < ::BaseServices::Delete
  include ::WorkPackages::Shared::UpdateAncestors

  private

  def persist(service_result)
    descendants = model.descendants.to_a

    result = super

    if result.success?
      update_ancestors_all_attributes(result.all_results).each do |ancestor_result|
        result.merge!(ancestor_result)
      end

      destroy_descendants(descendants, result)
      delete_associated(model)
    end

    result
  end

  def destroy(work_package)
    work_package.reload.destroy
  end

  def destroy_descendants(descendants, result)
    descendants.each do |descendant|
      result.add_dependent!(ServiceResult.new(success: descendant.destroy, result: descendant))
    end
  end

  def delete_associated(model)
    delete_notifications_resource(model.id)
  end

  def delete_notifications_resource(id)
    Notification
      .where(resource_type: :WorkPackage, resource_id: id)
      .delete_all
  end
end
