#-- encoding: UTF-8



class Wikis::Diff < Redmine::Helpers::Diff
  attr_reader :content_to, :content_from

  def initialize(content_to, content_from)
    @content_to = content_to
    @content_from = content_from
    super(content_to.data.text, content_from.data.text)
  end
end
