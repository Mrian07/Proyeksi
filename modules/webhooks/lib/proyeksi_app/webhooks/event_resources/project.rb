require_relative 'base'

module ProyeksiApp::Webhooks::EventResources
  class Project < Base
    class << self
      def notification_names
        [
          ProyeksiApp::Events::PROJECT_CREATED,
          ProyeksiApp::Events::PROJECT_UPDATED
        ]
      end

      def available_actions
        %i(updated created)
      end

      def resource_name
        I18n.t :label_project_plural
      end

      protected

      def handle_notification(payload, event_name)
        action = event_name.split('_').last
        event_name = prefixed_event_name(action)

        active_webhooks.with_event_name(event_name).pluck(:id).each do |id|
          ProjectWebhookJob.perform_later(id, payload[:project], event_name)
        end
      end
    end
  end
end
