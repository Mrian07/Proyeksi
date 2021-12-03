#-- encoding: UTF-8

class Queries::Members::Filters::MemberFilter < Queries::Filters::Base
  self.model = Member

  def human_name
    Member.human_attribute_name(name)
  end
end
