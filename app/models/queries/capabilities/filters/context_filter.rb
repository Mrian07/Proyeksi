

class Queries::Capabilities::Filters::ContextFilter < Queries::Capabilities::Filters::CapabilityFilter
  include Queries::Filters::Shared::ParsedFilter

  private

  def split_values
    values.map do |value|
      if (matches = value.match(/\A([gp])(\d*)\z/))
        {
          context_key: matches[1],
          context_id: matches[2]
        }
      end
    end
  end

  def value_conditions
    split_values.map do |value|
      if value[:context_id].present?
        "context_id = #{value[:context_id]}"
      else
        "context_id IS NULL"
      end
    end
  end
end
