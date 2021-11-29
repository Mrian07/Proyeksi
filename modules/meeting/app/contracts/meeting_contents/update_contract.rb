#-- encoding: UTF-8



module MeetingContents
  class UpdateContract < BaseContract
    validate :validate_editable

    private

    def validate_editable
      unless model.editable?
        errors.add :base, :error_readonly
      end
    end
  end
end
