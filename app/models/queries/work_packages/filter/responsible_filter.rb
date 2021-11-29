#-- encoding: UTF-8



class Queries::WorkPackages::Filter::ResponsibleFilter <
  Queries::WorkPackages::Filter::PrincipalBaseFilter
  def type
    :list_optional
  end

  def self.key
    :responsible_id
  end
end
