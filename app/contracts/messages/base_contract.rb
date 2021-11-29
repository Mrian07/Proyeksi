#-- encoding: UTF-8



module Messages
  class BaseContract < ::ModelContract
    include Attachments::ValidateReplacements

    def self.model
      Message
    end

    attribute :forum_id
    attribute :parent_id
    attribute :subject
    attribute :content
    attribute :last_reply
    attribute :locked
    attribute :sticky
  end
end
