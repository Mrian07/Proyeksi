#-- encoding: UTF-8

class Queries::Capabilities::Filters::PrincipalIdFilter < Queries::Capabilities::Filters::CapabilityFilter
  def type
    :integer
  end
end
