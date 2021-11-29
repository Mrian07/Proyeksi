

class Queries::Capabilities::Filters::IdFilter < Queries::Capabilities::Filters::CapabilityFilter
  include Queries::Filters::Shared::ParsedFilter

  private

  def split_values
    values.map do |value|
      if (matches = value.match(/\A(\w+\/\w+)\/([pg])(\d*)-(\d+)\z/))
        {
          action: matches[1],
          context_key: matches[2],
          context_id: matches[3],
          principal_id: matches[4]
        }
      end
    end
  end

  def value_conditions
    split_values.map do |value|
      conditions = ["action = '#{value[:action]}' AND principal_id = #{value[:principal_id]}"]

      conditions << if value[:context_id].present?
                      ["context_id = #{value[:context_id]}"]
                    else
                      ["context_id IS NULL"]
                    end

      "(#{conditions.join(' AND ')})"
    end
  end
end
