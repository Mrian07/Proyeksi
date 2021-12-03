#-- encoding: UTF-8

module Projects
  class DeleteProjectJob < UserJob
    queue_with_priority :low
    include ProyeksiApp::LocaleHelper

    attr_reader :project

    def execute(project:)
      @project = project

      service_call = delete_project

      if service_call.failure?
        log_service_failure(service_call)
      end
    rescue StandardError => e
      log_standard_error(e)
    end

    private

    def delete_project
      ::Projects::DeleteService
        .new(user: user, model: project)
        .call
    end

    def log_standard_error(e)
      logger.error('Encountered an error when trying to delete project '\
                   "'#{project}' : #{e.message} #{e.backtrace.join("\n")}")
    end

    def log_service_failure(service_call)
      logger.error "Failed to delete project #{project} in background job: " \
                   "#{service_call.message}"
    end

    def logger
      Delayed::Worker.logger
    end
  end
end
