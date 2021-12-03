module Attachments
  class CreateContract < ::ModelContract
    attribute :file
    attribute :filename
    attribute :filesize
    attribute :digest
    attribute :description
    attribute :content_type
    attribute :container
    attribute :container_type
    attribute :author

    validates :filename, presence: true

    validate :validate_attachments_addable
    validate :validate_container_addable
    validate :validate_author
    validate :validate_content_type

    private

    def validate_attachments_addable
      return if model.container

      if Redmine::Acts::Attachable.attachables.none?(&:attachments_addable?)
        errors.add(:base, :error_unauthorized)
      end
    end

    def validate_author
      unless model.author == user
        errors.add(:author, :invalid)
      end
    end

    def validate_container_addable
      return unless model.container

      errors.add(:base, :error_unauthorized) unless model.container.attachments_addable?(user)
    end

    ##
    # Validates the content type, if a whitelist is set
    def validate_content_type
      # If the whitelist is empty, assume all files are allowed
      # as before
      unless matches_whitelist?(attachment_whitelist)
        Rails.logger.info { "Uploaded file #{model.filename} with type #{model.content_type} does not match whitelist" }
        errors.add :content_type, :not_whitelisted, value: model.content_type
      end
    end

    ##
    # Get the user-defined whitelist or a custom whitelist
    # defined for this invocation
    def attachment_whitelist
      Array(options.fetch(:whitelist, Setting.attachment_whitelist))
    end

    ##
    # Returns whether the attachment matches the whitelist
    def matches_whitelist?(whitelist)
      return true if whitelist.empty?

      whitelist.include?(model.content_type) || whitelist.include?("*#{model.extension}")
    end
  end
end
