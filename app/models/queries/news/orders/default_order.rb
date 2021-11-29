#-- encoding: UTF-8



class Queries::News::Orders::DefaultOrder < Queries::Orders::Base
  self.model = News

  def self.key
    /\A(id|created_at|updated_at)\z/
  end
end
