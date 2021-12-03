#-- encoding: UTF-8

class Queries::PlaceholderUsers::Orders::DefaultOrder < Queries::Orders::Base
  self.model = PlaceholderUser

  def self.key
    /\A(id|name|created_at|updated_at)\z/
  end
end
