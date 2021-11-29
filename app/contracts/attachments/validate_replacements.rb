

require 'model_contract'

module Attachments
  module ValidateReplacements
    extend ActiveSupport::Concern

    included do
      validate :validate_attachments_replacements
    end

    private

    def validate_attachments_replacements
      model.attachments_replacements&.each do |attachment|
        error_if_attachment_assigned(attachment)
        error_if_other_user_attachment(attachment)
      end
    end

    def error_if_attachment_assigned(attachment)
      errors.add :attachments, :unchangeable if attachment.container && attachment.container != model
    end

    def error_if_other_user_attachment(attachment)
      errors.add :attachments, :does_not_exist if !attachment.container && attachment.author != user
    end
  end
end
