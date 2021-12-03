#-- encoding: UTF-8

module Attachments
  class SetAttributesService < ::BaseServices::SetAttributes
    def set_attributes(params)
      # Don't set the content type manually,
      # we always want to infer it
      super params.except :content_type
    end

    def set_default_attributes(params)
      model.author = user if model.author.nil?
    end
  end
end
