#-- encoding: UTF-8



module Projects
  class UnarchiveService < ::BaseServices::BaseContracted
    include Contracted
    include Projects::Concerns::UpdateDemoData

    def initialize(user:, model:, contract_class: Projects::UnarchiveContract)
      super(user: user, contract_class: contract_class)
      self.model = model
    end

    private

    def persist(service_call)
      activate_project(model)

      service_call
    end

    def activate_project(project)
      # We do not care for validations but want the timestamps to be updated
      project.update_attribute(:active, true)
    end
  end
end
