#-- encoding: UTF-8



module Documents
  class UpdateService < ::BaseServices::Update
    include Attachments::ReplaceAttachments
  end
end
