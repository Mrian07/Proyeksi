

module Budgets
  class CreateService < ::BaseServices::Create
    include Attachments::ReplaceAttachments
  end
end
