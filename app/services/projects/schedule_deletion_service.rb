#-- encoding: UTF-8

##
# Schedules the deletion of a project if allowed. As the deletion can be
# a lengthy process, the project is archived first
#
module Projects
  class ScheduleDeletionService < ::BaseServices::BaseContracted
    def initialize(user:, model:, contract_class: ::Projects::DeleteContract)
      super(user: user, contract_class: contract_class)
      self.model = model
    end

    private

    def before_perform(_params, _service_result)
      Projects::ArchiveService
        .new(user: user, model: model)
        .call
    end

    def persist(call)
      DeleteProjectJob.perform_later(user: user, project: model)
      call
    end
  end
end
