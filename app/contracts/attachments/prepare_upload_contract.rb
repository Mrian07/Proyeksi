module Attachments
  class PrepareUploadContract < CreateContract
    validate :validate_direct_uploads_active

    private

    def validate_direct_uploads_active
      errors.add :base, :not_available unless ProyeksiApp::Configuration.direct_uploads?
    end

    ##
    # The browser hasn't given a specific content type.
    # So we don't check the content type here during the prepare_upload step yet.
    #
    # We'll do it again later in the FinishDirectUploadJob where the normal create contract
    # without this opt-out is used, and where a more specific content type may be
    # determined.
    def validate_content_type
      return if pending_content_type?

      super
    end

    def pending_content_type?
      return false unless ProyeksiApp::Configuration.direct_uploads?

      model.content_type == ProyeksiApp::ContentTypeDetector::SENSIBLE_DEFAULT
    end
  end
end
