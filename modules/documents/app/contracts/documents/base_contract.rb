#-- encoding: UTF-8



module Documents
  class BaseContract < ::ModelContract
    include Attachments::ValidateReplacements

    def self.model
      Document
    end

    attribute :project
    attribute :category
    attribute :title
    attribute :description

    validate :validate_manage_allowed

    private

    def validate_manage_allowed
      unless user.allowed_to?(:manage_documents, model.project)
        errors.add :base, :error_unauthorized
      end
    end
  end
end
