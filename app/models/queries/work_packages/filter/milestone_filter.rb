#-- encoding: UTF-8

class Queries::WorkPackages::Filter::MilestoneFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  include Queries::Filters::Shared::BooleanFilter

  def self.key
    :is_milestone
  end

  def available?
    types.exists?
  end

  def dependency_class
    '::API::V3::Queries::Schemas::BooleanFilterDependencyRepresenter'
  end

  def where
    if positive?
      "type_id IN (#{milestone_subselect})"
    else
      "type_id NOT IN (#{milestone_subselect})"
    end
  end

  def positive?
    (operator == '=' && values == [ProyeksiApp::Database::DB_VALUE_TRUE]) ||
      (operator == '!' && values == [ProyeksiApp::Database::DB_VALUE_FALSE])
  end

  def human_name
    I18n.t('activerecord.attributes.type.is_milestone')
  end

  private

  def types
    project.nil? ? ::Type.order(Arel.sql('position')) : project.rolled_up_types
  end

  def milestone_subselect
    Type
      .where(is_milestone: true)
      .select(:id)
      .to_sql
  end
end
