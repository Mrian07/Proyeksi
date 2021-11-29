#-- encoding: UTF-8



module Budgets
  class UpdateService < ::BaseServices::Update
    include Attachments::ReplaceAttachments
  end
end
