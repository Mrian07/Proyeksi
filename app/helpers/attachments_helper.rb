#-- encoding: UTF-8



module AttachmentsHelper
  def to_utf8_for_attachments(str)
    forced_str = str.dup
    forced_str.force_encoding('UTF-8')
    return forced_str if forced_str.valid_encoding?

    str.encode('UTF-8', invalid: :replace, undef: :replace, replace: '') # better replace: '?'
  end

  ##
  # List attachments outside the edit form
  # allowing immediate removal or addition of attachments
  #
  # Within ckeditor-augmented-textarea-form, this attachment list is added automatically
  # when a resource is added.
  def list_attachments(resource)
    content_tag 'attachments',
                '',
                'data-resource': resource.to_json,
                'data-allow-uploading': false,
                'data-destroy-immediately': true
  end
end
