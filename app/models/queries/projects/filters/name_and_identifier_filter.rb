#-- encoding: UTF-8

class Queries::Projects::Filters::NameAndIdentifierFilter < Queries::Projects::Filters::ProjectFilter
  def type
    :string
  end

  def where
    case operator
    when '='
      where_equal
    when '!'
      where_not_equal
    when '~'
      where_contains
    when '!~'
      where_not_contains
    end
  end

  def human_name
    I18n.t('query_fields.name_or_identifier')
  end

  def self.key
    :name_and_identifier
  end

  private

  def concatenate_with_values(condition, concatenation)
    conditions = []
    assignments = []
    values.each do |value|
      conditions << condition
      assignments += [yield(value), yield(value)]
    end

    [conditions.join(" #{concatenation} "), *assignments]
  end

  def where_equal
    concatenate_with_values('LOWER(projects.identifier) = ? OR LOWER(projects.name) = ?', 'OR', &:downcase)
  end

  def where_not_equal
    where_not(where_equal)
  end

  def where_contains
    concatenate_with_values('LOWER(projects.identifier) LIKE ? OR LOWER(projects.name) LIKE ?', 'OR') do |value|
      "%#{value.downcase}%"
    end
  end

  def where_not_contains
    where_not(where_contains)
  end

  def where_not(condition)
    conditions = condition
    conditions[0] = "NOT(#{conditions[0]})"
    conditions
  end
end
