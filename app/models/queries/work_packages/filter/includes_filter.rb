#-- encoding: UTF-8



# Filter for all work packages that are (or are not) blocking work packages with the provided values.

class Queries::WorkPackages::Filter::IncludesFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  include ::Queries::WorkPackages::Filter::FilterOnDirectedRelationsMixin

  def relation_type
    ::Relation::TYPE_INCLUDES
  end

  private

  def relation_filter
    { to_id: values }
  end

  def relation_select
    :from_id
  end
end
