#-- encoding: UTF-8

class Queries::News::Filters::NewsFilter < Queries::Filters::Base
  self.model = News

  def human_name
    News.human_attribute_name(name)
  end
end
