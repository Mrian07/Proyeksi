#-- encoding: UTF-8



module CustomActions::Actions::Strategies::Integer
  include CustomActions::ValuesToInteger
  include CustomActions::Actions::Strategies::ValidateInRange

  def type
    :integer_property
  end
end
