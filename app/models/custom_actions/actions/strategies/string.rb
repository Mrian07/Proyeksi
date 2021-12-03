#-- encoding: UTF-8

module CustomActions::Actions::Strategies::String
  include CustomActions::Actions::Strategies::ValuesToString

  def type
    :string_property
  end
end
