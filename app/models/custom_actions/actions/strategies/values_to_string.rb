

module CustomActions::Actions::Strategies::ValuesToString
  def values=(values)
    super(Array(values).map { |v| to_string_or_nil(v) }.uniq)
  end

  private

  def to_string_or_nil(value)
    return nil if value.nil?

    String(value)
  rescue TypeError, ArgumentError
    nil
  end
end
