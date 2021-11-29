#-- encoding: UTF-8



module Documents
  class CreateService < ::BaseServices::Create
    include Attachments::ReplaceAttachments
  end
end
