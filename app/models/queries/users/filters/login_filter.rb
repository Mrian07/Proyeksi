#-- encoding: UTF-8



class Queries::Users::Filters::LoginFilter < Queries::Users::Filters::UserFilter
  def type
    :string
  end

  def self.key
    :login
  end
end
