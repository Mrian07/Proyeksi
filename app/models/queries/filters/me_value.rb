#-- encoding: UTF-8



class Queries::Filters::MeValue
  KEY = 'me'.freeze

  def id
    KEY
  end

  def name
    I18n.t(:label_me)
  end

  def class
    User
  end
end
