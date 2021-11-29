#-- encoding: UTF-8



class WikiPages::CreateService < ::BaseServices::Create
  include Attachments::ReplaceAttachments
end
