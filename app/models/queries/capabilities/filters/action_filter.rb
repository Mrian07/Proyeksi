class Queries::Capabilities::Filters::ActionFilter < Queries::Capabilities::Filters::CapabilityFilter
  include Queries::Filters::Shared::ParsedFilter

  private

  def split_values
    values.map do |value|
      if (matches = value.match(/\A([a-z]+\/[a-z]+)\z/))
        {
          action: matches[1]
        }
      end
    end
  end

  def value_conditions
    split_values.map do |value|
      "action = '#{value[:action]}'"
    end
  end
end
