#-- encoding: UTF-8

class Queries::WorkPackages::Filter::FilterConfiguration
  attr_accessor(:filter_class, :filter_name, :operator)

  def initialize(filter_class, filter_name, operator)
    @filter_class = filter_class
    @filter_name = filter_name
    @operator = operator
  end
end
