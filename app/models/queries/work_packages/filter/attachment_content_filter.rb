#-- encoding: UTF-8

class Queries::WorkPackages::Filter::AttachmentContentFilter < Queries::WorkPackages::Filter::AttachmentBaseFilter
  def self.key
    :attachment_content
  end

  def name
    :attachment_content
  end

  def human_name
    Attachment.human_attribute_name('attachment_content')
  end

  def search_column
    'fulltext'
  end
end
