#-- encoding: UTF-8

class Queries::Users::Orders::DefaultOrder < Queries::Orders::Base
  self.model = User

  def self.key
    /\A(id|lastname|firstname|mail|login)\z/
  end
end
