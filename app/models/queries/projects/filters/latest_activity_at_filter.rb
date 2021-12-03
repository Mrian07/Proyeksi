#-- encoding: UTF-8

class Queries::Projects::Filters::LatestActivityAtFilter < Queries::Projects::Filters::ProjectFilter
  self.model = Project.with_latest_activity

  def type
    :datetime_past
  end

  def self.key
    :latest_activity_at
  end

  def name
    :latest_activity_at
  end

  def available?
    User.current.admin?
  end

  def human_name
    I18n.t('activerecord.attributes.project.latest_activity_at')
  end

  def where
    operator_strategy.sql_for_field(values, "activity", self.class.key)
  end
end
