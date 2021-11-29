

module Bim
  module IfcModels
    class UpdateService < ::BaseServices::Update
      protected

      def before_perform(params, _service_result)
        @ifc_attachment_updated = params[:ifc_attachment].present?

        super
      end

      def after_perform(service_result)
        if service_result.success?
          # As the attachments association does not have the autosave option, we need to remove the
          # attachments ourselves
          model.attachments.select(&:marked_for_destruction?).each(&:destroy)

          if @ifc_attachment_updated
            model.update(conversion_status: ::Bim::IfcModels::IfcModel.conversion_statuses[:pending],
                         conversion_error_message: nil)
            
            IfcConversionJob.perform_later(service_result.result)
          end
        end

        service_result
      end
    end
  end
end
