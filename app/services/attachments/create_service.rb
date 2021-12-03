module Attachments
  class CreateService < BaseService
    include TouchContainer

    around_call :error_wrapped_call

    def persist(call)
      attachment = call.result
      if attachment.container
        in_container_mutex(attachment.container) { super }
      else
        super
      end
    end

    def in_container_mutex(container)
      ProyeksiApp::Mutex.with_advisory_lock_transaction(container) do
        yield.tap do
          # Get the latest attachments to ensure having them all for journalization.
          # We just created an attachment and a different worker might have added attachments
          # in the meantime, e.g when bulk uploading.
          container.attachments.reload
        end
      end
    end

    def after_perform(call)
      attachment = call.result
      container = attachment.container

      touch(container) unless container.nil?

      ProyeksiApp::Notifications.send(
        ProyeksiApp::Events::ATTACHMENT_CREATED,
        attachment: attachment
      )

      call
    end

    def error_wrapped_call
      yield
    rescue StandardError => e
      log_attachment_saving_error(e)

      message =
        if e&.class&.to_s == 'Errno::EACCES'
          I18n.t('api_v3.errors.unable_to_create_attachment_permissions')
        else
          I18n.t('api_v3.errors.unable_to_create_attachment')
        end
      raise message
    end

    def log_attachment_saving_error(error)
      message = "Failed to save attachment: #{error&.class} - #{error&.message || 'Unknown error'}"

      ProyeksiApp.logger.error message
    end
  end
end
