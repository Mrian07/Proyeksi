

module Attachments
  class PrepareUploadService < BaseService
    def persist(call)
      attachment = call.result

      if attachment.save
        attachment.reload # necessary so that the fog file uploader path is correct
        ServiceResult.new success: true, result: attachment
      else
        ServiceResult.new success: false, result: attachment
      end
    end

    private

    def attributes_service_class
      SetPreparedAttributesService
    end
  end
end
