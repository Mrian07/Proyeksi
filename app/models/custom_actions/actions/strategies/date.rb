#-- encoding: UTF-8

module CustomActions::Actions::Strategies::Date
  def values=(values)
    super(Array(values).map { |v| to_date_or_nil(v) }.uniq)
  end

  def type
    :date_property
  end

  def apply(work_package)
    accessor = :"#{self.class.key}="
    if work_package.respond_to? accessor
      work_package.send(accessor, date_to_apply)
    end
  end

  private

  def date_to_apply
    if values.first == '%CURRENT_DATE%'
      Date.today
    else
      values.first
    end
  end

  def to_date_or_nil(value)
    case value
    when nil, '%CURRENT_DATE%'
      value
    else
      value.to_date
    end
  rescue TypeError, ArgumentError
    nil
  end
end
