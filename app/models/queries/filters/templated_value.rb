#-- encoding: UTF-8

class Queries::Filters::TemplatedValue
  KEY = '{id}'.freeze
  DEPRECATED_KEY = 'templated'.freeze

  attr_accessor :templated_class

  def initialize(templated_class)
    self.templated_class = templated_class
  end

  def id
    '{id}'
  end

  def name
    nil
  end

  def class
    templated_class
  end
end
