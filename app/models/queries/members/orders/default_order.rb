#-- encoding: UTF-8

class Queries::Members::Orders::DefaultOrder < Queries::Orders::Base
  self.model = Member

  def self.key
    /\A(id|created_at|updated_at)\z/
  end
end
