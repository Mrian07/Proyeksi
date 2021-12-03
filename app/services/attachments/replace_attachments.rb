#-- encoding: UTF-8

module Attachments
  module ReplaceAttachments
    extend ActiveSupport::Concern

    included do
      private

      def set_attributes(attributes)
        call = super

        if call.success? && call.result.attachments_replacements
          call.result.attachments = call.result.attachments_replacements
        end

        call
      end
    end
  end
end
