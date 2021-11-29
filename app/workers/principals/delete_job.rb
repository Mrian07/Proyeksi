#-- encoding: UTF-8



class Principals::DeleteJob < ApplicationJob
  queue_with_priority :low

  def perform(principal)
    Principal.transaction do
      delete_associated(principal)
      replace_references(principal)
      update_cost_queries(principal)
      remove_members(principal)

      principal.destroy
    end
  end

  private

  def replace_references(principal)
    Principals::ReplaceReferencesService
      .new
      .call(from: principal, to: DeletedUser.first)
      .tap do |call|
      raise ActiveRecord::Rollback if call.failure?
    end
  end

  def delete_associated(principal)
    delete_notifications(principal)
    delete_private_queries(principal)
  end

  def delete_notifications(principal)
    ::Notification.where(recipient: principal).delete_all
  end

  def delete_private_queries(principal)
    ::Query.where(user_id: principal.id, is_public: false).delete_all
    CostQuery.where(user_id: principal.id, is_public: false).delete_all
  end

  def update_cost_queries(principal)
    CostQuery.in_batches.each_record do |query|
      serialized = query.serialized

      serialized[:filters] = serialized[:filters].map do |name, options|
        remove_cost_query_values(name, options, principal)
      end.compact

      CostQuery.where(id: query.id).update_all(serialized: serialized)
    end
  end

  def remove_cost_query_values(name, options, principal)
    options[:values].delete(principal.id.to_s) if %w[UserId AuthorId AssignedToId ResponsibleId].include?(name)

    if options[:values].nil? || options[:values].any?
      [name, options]
    end
  end

  def remove_members(principal)
    principal.members.each do |member|
      Members::DeleteService
        .new(user: User.current, contract_class: EmptyContract, model: member)
        .call
    end
  end
end
