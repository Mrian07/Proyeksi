#-- encoding: UTF-8



class Queries::Documents::Orders::DefaultOrder < Queries::Orders::Base
  self.model = Document

  def self.key
    /\A(id|created_at|updated_at)\z/
  end
end
