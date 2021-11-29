

module Attachments
  class BuildService < BaseService
    private

    def persist(service_result)
      attachment = service_result.result
      add_to_association(attachment)

      unless attachment.valid?
        service_result.errors = attachment.errors
        service_result.success = false
      end

      service_result
    end

    def add_to_association(attachment)
      return unless attachment.container

      attachment.container.association(:attachments).add_to_target(attachment)
    end
  end
end
