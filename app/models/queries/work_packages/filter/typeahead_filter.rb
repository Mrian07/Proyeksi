#-- encoding: UTF-8

class Queries::WorkPackages::Filter::TypeaheadFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  def type
    :search
  end

  def where
    parts = values.map(&:split).flatten

    parts.map do |part|
      conditions = [subject_condition(part),
                    project_name_condition(part)]

      if (match = part.match(/^#?(\d+)$/))
        conditions << id_condition(match[1])
      end

      "(#{conditions.join(' OR ')})"
    end.join(' AND ')
  end

  def subject_condition(string)
    Queries::Operators::Contains.sql_for_field([string], WorkPackage.table_name, 'subject')
  end

  def project_name_condition(string)
    Queries::Operators::Contains.sql_for_field([string], Project.table_name, 'name')
  end

  def id_condition(string)
    "#{WorkPackage.table_name}.id::varchar(20) LIKE '%#{string}%'"
  end
end
