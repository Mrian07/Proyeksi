#-- encoding: UTF-8

module ReportsHelper
  include WorkPackagesFilterHelper

  def aggregate(data, criteria)
    data&.inject(0) do |sum, row|
      match = criteria&.all? do |k, v|
        row[k].to_s == v.to_s || (k == 'closed' && row[k] == ActiveRecord::Type::Boolean.new.cast(v))
      end

      sum += row['total'].to_i if match

      sum
    end || 0
  end

  def aggregate_link(data, criteria, *args)
    a = aggregate data, criteria
    a.positive? ? link_to(h(a), *args) : '-'
  end
end
