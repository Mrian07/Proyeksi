module CustomActions::ValuesToInteger
  def values=(values)
    super(Array(values).map { |v| to_integer_or_nil(v) }.uniq)
  end

  private

  def to_integer_or_nil(value)
    return nil if value.nil?

    Integer(value)
  rescue TypeError, ArgumentError
    nil
  end
end
