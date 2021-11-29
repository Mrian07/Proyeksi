#-- encoding: UTF-8



class Queries::WorkPackages::Filter::SubjectOrIdFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  include Queries::WorkPackages::Filter::OrFilterForWpMixin

  CONTAINS_OPERATOR = '~'.freeze
  EQUALS_OPERATOR = '='.freeze

  FILTERS = [
    Queries::WorkPackages::Filter::FilterConfiguration.new(
      Queries::WorkPackages::Filter::SubjectFilter,
      :subject,
      CONTAINS_OPERATOR
    ),
    Queries::WorkPackages::Filter::FilterConfiguration.new(
      Queries::WorkPackages::Filter::IdFilter,
      :id,
      EQUALS_OPERATOR
    )
  ].freeze

  def self.key
    :subject_or_id
  end

  def name
    :subject_or_id
  end

  def type
    :search
  end

  def human_name
    I18n.t('label_subject_or_id')
  end

  def filter_configurations
    FILTERS
  end
end
