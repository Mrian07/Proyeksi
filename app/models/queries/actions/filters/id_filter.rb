class Queries::Actions::Filters::IdFilter < Queries::Actions::Filters::ActionFilter
  include ::Queries::Filters::Shared::ParsedFilter

  private

  def split_values
    values.map do |value|
      if (matches = value.match(/\A(\w+\/\w+)\z/))
        {
          action: matches[1]
        }
      end
    end
  end

  def value_conditions
    split_values.map do |value|
      "id = '#{value[:action]}'"
    end
  end
end
