#-- encoding: UTF-8

class Queries::Groups::Orders::DefaultOrder < Queries::Orders::Base
  self.model = Group

  def self.key
    /\A(id|created_at|updated_at)\z/
  end
end
