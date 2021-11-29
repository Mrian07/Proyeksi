

class CostQuery::Filter::CustomFieldEntries < Report::Filter::Base
  extend CostQuery::CustomFieldMixin

  on_prepare do
    applies_for :label_work_package_attributes
    # redmine internals just suck
    case custom_field.field_format
    when 'string', 'text' then use :string_operators
    when 'list'           then use :null_operators
    when 'date'           then use :time_operators
    when 'int', 'float'   then use :integer_operators
    when 'bool'
      @possible_values = [['true', 't'], ['false', 'f']]
      use :null_operators
    else
      fail "cannot handle #{custom_field.field_format.inspect}"
    end
  end

  def self.available_values(*)
    @possible_values || get_possible_values
  end

  def self.get_possible_values
    if custom_field.field_format == 'list'
      # Treat list CFs values as string options again, since
      # aggregation of groups are made by the values as well
      # and otherwise, it won't work as a filter.
      custom_field.possible_values.map { |co| [co.value, co.value] }
    else
      custom_field.possible_values
    end
  end
end
