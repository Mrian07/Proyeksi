#-- encoding: UTF-8



class ::Query::SortCriteria < ::SortHelper::SortCriteria
  attr_reader :available_columns

  ##
  # Initialize the sort criteria with the set of columns
  def initialize(available_columns)
    super()
    @available_columns = available_columns
  end

  ##
  # Building the query sort criteria needs to respect
  # specific options of the column
  def to_a
    criteria_with_default_order
      .map { |attribute, order| [find_column(attribute), @available_criteria[attribute], order] }
      .reject { |column, criterion, _| column.nil? || criterion.nil? }
      .map { |column, criterion, order| [column, execute_criterion(criterion), order] }
      .map { |column, criterion, order| append_order(column, Array(criterion), order) }
      .compact
  end

  private

  ##
  # Find the matching column for the attribute
  def find_column(attribute)
    available_columns.detect { |column| column.name.to_s == attribute.to_s }
  end

  ##
  # append the order to the criteria
  # as well as any order handling by the column itself
  def append_order(column, criterion, asc = true)
    ordered_criterion = append_direction(criterion, asc)

    ordered_criterion.map { |statement| "#{statement} #{column.null_handling(asc)}".strip }
  end

  def execute_criterion(criteria)
    Array(criteria).map do |criterion|
      if criterion.respond_to?(:call)
        criterion.call
      else
        criterion
      end
    end
  end

  def criteria_with_default_order
    if @criteria.none? { |attribute, _| attribute == 'id' }
      @criteria + [['id', false]]
    else
      @criteria
    end
  end
end
