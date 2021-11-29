#-- encoding: UTF-8



class Queries::WorkPackages::Columns::CustomFieldColumn < Queries::WorkPackages::Columns::WorkPackageColumn
  def initialize(custom_field)
    super

    @cf = custom_field

    set_name!
    set_sortable!
    set_groupable!
    set_summable!
  end

  def groupable_custom_field?(custom_field)
    %w(list date bool int).include?(custom_field.field_format)
  end

  def caption
    @cf.name
  end

  def null_handling(asc)
    custom_field.null_handling(asc)
  end

  def custom_field
    @cf
  end

  def value(work_package)
    work_package.formatted_custom_value_for(@cf.id)
  end

  def self.instances(context = nil)
    if context
      context.all_work_package_custom_fields
    else
      WorkPackageCustomField.all
    end
      .reject { |cf| cf.field_format == 'text' }
      .map { |cf| new(cf) }
  end

  private

  def set_name!
    self.name = "cf_#{custom_field.id}".to_sym
  end

  def set_sortable!
    self.sortable = custom_field.order_statements || false
  end

  def set_groupable!
    self.groupable = custom_field.group_by_statement if groupable_custom_field?(custom_field)
    self.groupable ||= false
  end

  def set_summable!
    self.summable = if %w(float int).include?(custom_field.field_format)
                      select = summable_select_statement

                      ->(query, grouped) {
                        Queries::WorkPackages::Columns::WorkPackageColumn
                          .scoped_column_sum(summable_scope(query), select, grouped && query.group_by_statement)
                      }
                    else
                      false
                    end
  end

  def summable_scope(query)
    WorkPackage
      .where(id: query.results.work_packages)
      .left_joins(:custom_values)
      .where(custom_values: { custom_field: custom_field })
      .where.not(custom_values: { value: nil })
      .where.not(custom_values: { value: '' })
  end

  def summable_select_statement
    if custom_field.field_format == 'int'
      "COALESCE(SUM(value::BIGINT)::BIGINT, 0) #{name}"
    else
      "COALESCE(ROUND(SUM(value::NUMERIC), 2)::FLOAT, 0.0) #{name}"
    end
  end
end
