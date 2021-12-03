#-- encoding: UTF-8

module ::Query::Results::Sums
  include ActionView::Helpers::NumberHelper

  def all_total_sums
    group_sums = sums_select

    query.summed_up_columns.inject({}) do |result, column|
      value = group_sums.first
      result[column] = value[column.name.to_s] unless value.nil?
      result
    end
  end

  def all_group_sums
    return nil unless query.grouped?

    sums_by_id = sums_select(true).inject({}) do |result, group_sum|
      result[group_sum['id']] = {}

      query.summed_up_columns.each do |column|
        result[group_sum['id']][column] = group_sum[column.name.to_s]
      end

      result
    end

    transform_group_keys(sums_by_id)
  end

  private

  def sums_select(grouped = false)
    select = if grouped
               ["work_packages.id"]
             else
               []
             end

    select += query.summed_up_columns.map(&:summable_select)

    sql = <<~SQL
      SELECT #{select.join(', ')}
      FROM (#{sums_work_package_scope(grouped).to_sql}) work_packages
      #{sums_callable_joins(grouped)}
    SQL

    connection = ActiveRecord::Base.connection

    connection.uncached do
      connection.select_all(sql)
    end
  end

  def sums_work_package_scope(grouped)
    scope = WorkPackage
              .where(id: work_packages)
              .except(:order, :select)
              .select(sums_work_package_scope_selects(grouped))

    if grouped
      scope.group(query.group_by_statement)
    else
      scope
    end
  end

  def sums_callable_joins(grouped)
    callable_summed_up_columns
      .map do |c|
      join_condition = if grouped
                         "#{c.name}.id = work_packages.id OR #{c.name}.id IS NULL AND work_packages.id IS NULL"
                       else
                         "TRUE"
                       end

      "LEFT OUTER JOIN (#{c.summable.(query, grouped).to_sql}) #{c.name} ON #{join_condition}"
    end
      .join(' ')
  end

  def sums_work_package_scope_selects(grouped)
    select = if grouped
               ["#{query.group_by_statement} id"]
             else
               []
             end

    select + query.summed_up_columns.map(&:summable_work_packages_select).compact.map { |c| "SUM(#{c}) #{c}" }
  end

  def callable_summed_up_columns
    query.summed_up_columns.select { |column| column.summable.respond_to?(:call) }
  end

  def non_callable_summed_up_columns
    query.summed_up_columns.map { |column| column.summable.respond_to?(:call) }
  end
end
