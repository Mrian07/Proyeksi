#-- encoding: UTF-8

class WorkPackages::CreateService < ::BaseServices::BaseCallable
  include ::WorkPackages::Shared::UpdateAncestors
  include ::Shared::ServiceContext

  attr_accessor :user,
                :contract_class

  def initialize(user:, contract_class: WorkPackages::CreateContract)
    self.user = user
    self.contract_class = contract_class
  end

  def perform(work_package: WorkPackage.new,
              send_notifications: true,
              **attributes)
    in_user_context(send_notifications) do
      create(attributes, work_package)
    end
  end

  protected

  def create(attributes, work_package)
    result = set_attributes(attributes, work_package)

    result.success = if result.success
                       replace_attachments(work_package)
                     else
                       false
                     end

    if result.success?
      result.merge!(reschedule_related(work_package))

      update_ancestors_all_attributes(result.all_results).each do |ancestor_result|
        result.merge!(ancestor_result)
      end

      set_user_as_watcher(work_package)
    else
      result.success = false
    end

    result
  end

  def set_attributes(attributes, wp)
    attributes_service_class
      .new(user: user,
           model: wp,
           contract_class: contract_class)
      .call(attributes)
  end

  def replace_attachments(work_package)
    work_package.attachments = work_package.attachments_replacements if work_package.attachments_replacements
    work_package.save
  end

  def reschedule_related(work_package)
    result = WorkPackages::SetScheduleService
               .new(user: user,
                    work_package: work_package)
               .call

    result.self_and_dependent.each do |r|
      unless r.result.save
        result.success = false
        r.errors = r.result.errors
      end
    end

    result
  end

  def set_user_as_watcher(work_package)
    # We don't care if it fails here. If it does
    # the user simply does not become watcher
    Services::CreateWatcher
      .new(work_package, user)
      .run(send_notifications: false)
  end

  def attributes_service_class
    ::WorkPackages::SetAttributesService
  end
end
