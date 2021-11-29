#-- encoding: UTF-8



class Queries::Projects::Orders::DefaultOrder < Queries::Orders::Base
  self.model = Project

  def self.key
    /\A(id|created_at|public|lft)\z/
  end
end
