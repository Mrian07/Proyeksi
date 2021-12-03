#-- encoding: UTF-8

module Attachments
  module SetReplacements
    extend ActiveSupport::Concern

    included do
      private

      def set_attributes(attributes)
        set_attachments_attributes(attributes)

        super
      end

      def set_attachments_attributes(attributes)
        attachment_ids = attributes.delete(:attachment_ids)

        return unless attachment_ids

        model.attachments_replacements = Attachment.where(id: attachment_ids)
      end
    end
  end
end
