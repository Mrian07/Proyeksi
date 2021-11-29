#-- encoding: UTF-8



module MeetingContents
  class BaseContract < ::ModelContract
    include Attachments::ValidateReplacements

    def self.model
      MeetingContent
    end

    attribute :meeting
    attribute :text
    attribute :lock_version
    attribute :locked
    attribute :type

    validate :type_in_allowed

    private

    def type_in_allowed
      unless [MeetingAgenda.name, MeetingMinutes.name].include?(model.type)
        errors.add(:type, :inclusion)
      end
    end
  end
end
