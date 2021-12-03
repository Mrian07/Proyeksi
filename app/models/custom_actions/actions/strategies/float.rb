#-- encoding: UTF-8

module CustomActions::Actions::Strategies::Float
  include CustomActions::Actions::Strategies::ValidateInRange

  def values=(values)
    super(Array(values).map { |v| to_float_or_nil(v) }.uniq)
  end

  def type
    :float_property
  end

  def to_float_or_nil(value)
    return nil if value.nil?

    Float(value)
  rescue TypeError, ArgumentError
    nil
  end
end
