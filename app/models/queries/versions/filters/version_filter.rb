#-- encoding: UTF-8

class Queries::Versions::Filters::VersionFilter < Queries::Filters::Base
  self.model = Version

  def human_name
    Version.human_attribute_name(name)
  end
end
