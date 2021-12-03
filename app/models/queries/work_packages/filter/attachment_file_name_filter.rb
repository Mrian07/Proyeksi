#-- encoding: UTF-8

class Queries::WorkPackages::Filter::AttachmentFileNameFilter < Queries::WorkPackages::Filter::AttachmentBaseFilter
  def self.key
    :attachment_file_name
  end

  def name
    :attachment_file_name
  end

  def human_name
    Attachment.human_attribute_name('attachment_file_name')
  end

  def search_column
    'file'
  end

  def normalization_type
    :filename
  end
end
