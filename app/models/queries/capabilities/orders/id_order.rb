#-- encoding: UTF-8

class Queries::Capabilities::Orders::IdOrder < Queries::Orders::Base
  self.model = Capability

  def self.key
    :id
  end

  def name
    :action
  end
end
