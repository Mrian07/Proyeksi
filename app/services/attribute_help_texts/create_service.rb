#-- encoding: UTF-8



module AttributeHelpTexts
  class CreateService < ::BaseServices::Create
    include Attachments::ReplaceAttachments

    def instance(params)
      instance_class.new type: params[:type]
    end
  end
end
