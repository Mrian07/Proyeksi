#-- encoding: UTF-8



class Queries::WorkPackages::Filter::CommentFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  include Queries::WorkPackages::Filter::TextFilterOnJoinMixin

  def type
    :text
  end

  private

  def where_condition
    <<-SQL
     SELECT 1 FROM #{journal_table}
     WHERE #{journal_table}.journable_id = #{WorkPackage.table_name}.id
	   AND #{journal_table}.journable_type = '#{WorkPackage.name}'
     AND #{notes_condition}
    SQL
  end

  def notes_condition
    Queries::Operators::Contains.sql_for_field(values, journal_table, 'notes')
  end

  def journal_table
    Journal.table_name
  end
end
