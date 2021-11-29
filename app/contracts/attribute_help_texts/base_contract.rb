

module AttributeHelpTexts
  class BaseContract < ::ModelContract
    include RequiresAdminGuard
    include Attachments::ValidateReplacements

    def self.model
      AttributeHelpText
    end

    attribute :type
    attribute :attribute_name
    attribute :help_text
  end
end
