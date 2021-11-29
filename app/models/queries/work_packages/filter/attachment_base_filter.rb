#-- encoding: UTF-8



class Queries::WorkPackages::Filter::AttachmentBaseFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  include Queries::WorkPackages::Filter::TextFilterOnJoinMixin

  def type
    :text
  end

  def available?
    EnterpriseToken.allows_to?(:attachment_filters) && OpenProject::Database.allows_tsv?
  end

  protected

  def where_condition
    <<-SQL
      SELECT 1 FROM #{attachment_table}
      WHERE #{attachment_table}.container_id = #{WorkPackage.table_name}.id
      AND #{attachment_table}.container_type = '#{WorkPackage.name}'
      AND #{tsv_condition}
    SQL
  end

  def attachment_table
    Attachment.table_name
  end

  def tsv_condition
    OpenProject::FullTextSearch.tsv_where(attachment_table,
                                          search_column,
                                          values.first,
                                          normalization: normalization_type)
  end

  def search_column
    raise NotImplementedError
  end

  def normalization_type
    :text
  end
end
