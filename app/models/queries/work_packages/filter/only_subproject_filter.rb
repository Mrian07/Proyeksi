#-- encoding: UTF-8



class Queries::WorkPackages::Filter::OnlySubprojectFilter <
  Queries::WorkPackages::Filter::SubprojectFilter
  def type
    :list
  end

  def human_name
    I18n.t('query_fields.only_subproject_id')
  end

  def self.key
    :only_subproject_id
  end

  private

  def ids_for_where
    ids_for_where_subproject
  end
end
