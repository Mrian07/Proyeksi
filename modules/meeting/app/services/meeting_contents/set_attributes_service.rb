#-- encoding: UTF-8



module MeetingContents
  class SetAttributesService < ::BaseServices::SetAttributes
    include Attachments::SetReplacements


    def set_default_attributes(_params)
      model.change_by_system do
        model.author = user if model.author.nil?
      end
    end
  end
end
