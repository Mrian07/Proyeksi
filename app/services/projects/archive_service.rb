#-- encoding: UTF-8



module Projects
  class ArchiveService < ::BaseServices::BaseContracted
    include Contracted
    include Projects::Concerns::UpdateDemoData

    def initialize(user:, model:, contract_class: Projects::ArchiveContract)
      super(user: user, contract_class: contract_class)
      self.model = model
    end

    private

    def persist(service_call)
      archive_project(model) and model.children.each do |child|
        archive_project(child)
      end

      service_call
    end

    def archive_project(project)
      # We do not care for validations but want the timestamps to be updated
      project.update_attribute(:active, false)
    end
  end
end
