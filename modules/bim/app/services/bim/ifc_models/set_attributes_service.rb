#-- encoding: UTF-8



module Bim
  module IfcModels
    class SetAttributesService < ::BaseServices::SetAttributes
      protected

      def set_attributes(params)
        model.project = params[:project] if params.key?(:project)
        set_ifc_attachment(params.delete(:ifc_attachment))

        super

        model.change_by_system do
          model.uploader = model.ifc_attachment&.author
        end
      end

      def set_default_attributes(_params)
        set_title
      end

      def validate_and_result
        super.tap do |call|
          # map errors on attachments to better display them
          if call.errors[:attachments].any?
            model.ifc_attachment.errors.details.each do |_, errors|
              errors.each do |error|
                call.errors.add(:attachments, error[:error], **error.except(:error))
              end
            end
          end
        end
      end

      def set_title
        model.title ||= model.ifc_attachment&.file&.filename&.gsub(/\.\w+$/, '')
      end

      def set_ifc_attachment(ifc_attachment)
        return unless ifc_attachment

        model.attachments.each(&:mark_for_destruction)

        if ifc_attachment.is_a?(Attachment)
          ifc_attachment.description = "ifc"
          ifc_attachment.save! unless ifc_attachment.new_record?

          model.attachments << ifc_attachment
        else
          ::Attachments::BuildService
            .bypass_whitelist(user: user)
            .call(file: ifc_attachment, container: model, filename: ifc_attachment.original_filename, description: 'ifc')
        end
      end
    end
  end
end
