#-- encoding: UTF-8



module CustomActions::Actions::Strategies::Text
  include CustomActions::Actions::Strategies::ValuesToString

  def type
    :text_property
  end
end
