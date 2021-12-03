#-- encoding: UTF-8

class Queries::Capabilities::Filters::CapabilityFilter < Queries::Filters::Base
  self.model = Capability

  def human_name
    Capability.human_attribute_name(name)
  end

  def where
    operator_strategy.sql_for_field(values, 'capabilities', self.class.key)
  end
end
