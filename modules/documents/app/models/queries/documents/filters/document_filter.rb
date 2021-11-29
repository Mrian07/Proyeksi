#-- encoding: UTF-8



class Queries::Documents::Filters::DocumentFilter < Queries::Filters::Base
  self.model = Document

  def human_name
    Document.human_attribute_name(name)
  end
end
