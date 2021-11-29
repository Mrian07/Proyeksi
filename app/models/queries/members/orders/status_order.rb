#-- encoding: UTF-8



class Queries::Members::Orders::StatusOrder < Queries::Orders::Base
  self.model = Member

  def self.key
    :status
  end

  def joins
    :principal
  end

  def name
    "#{Principal.table_name}.status"
  end
end
