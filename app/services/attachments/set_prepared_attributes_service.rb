#-- encoding: UTF-8



module Attachments
  class SetPreparedAttributesService < SetAttributesService
    private

    def set_attributes(params)
      super

      set_prepared_attributes params
    end

    def set_prepared_attributes(params)
      # We need to do it like this because `file` is an uploader which expects a File (not a string)
      # to upload usually. But in this case the data has already been uploaded and we just point to it.
      model[:file] = pending_direct_upload_filename(params[:filename])

      # Explicitly set the filesize from metadata
      # as the provided file is not actually uploaded
      model.filesize = params[:filesize]

      model.extend(ProyeksiApp::ChangedBySystem)
      model.change_by_system do
        model.downloads = -1
        # Set a preliminary content type as the file is not present
        # The content type will be updated by the FinishDirectUploadJob if necessary.
        model.content_type = params[:content_type].presence || ProyeksiApp::ContentTypeDetector::SENSIBLE_DEFAULT
      end
    end

    # The name has to be in the same format as what Carrierwave will produce later on. If they are different,
    # Carrierwave will alter the name (both local and remote) whenever the attachment is saved with the remote
    # file loaded.
    def pending_direct_upload_filename(filename)
      CarrierWave::SanitizedFile.new(nil).send(:sanitize, filename)
    end
  end
end
