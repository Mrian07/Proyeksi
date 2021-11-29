#-- encoding: UTF-8



# TODO: This is but a stub
module Messages
  class SetAttributesService < ::BaseServices::SetAttributes
    include Attachments::SetReplacements

    private

    def set_default_attributes(*)
      set_default_author
    end

    def set_default_author
      model.change_by_system do
        model.author = user
      end
    end
  end
end
