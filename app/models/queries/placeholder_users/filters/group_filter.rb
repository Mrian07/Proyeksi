#-- encoding: UTF-8

class Queries::PlaceholderUsers::Filters::GroupFilter < Queries::PlaceholderUsers::Filters::PlaceholderUserFilter
  include Queries::Filters::Shared::GroupFilter

  self.model = PlaceholderUser

  def human_name
    PlaceholderUser.human_attribute_name(name)
  end

  private

  def group_subselect
    PlaceholderUser.in_group(values).select(:id).to_sql
  end

  def any_group_subselect
    PlaceholderUser.within_group([]).select(:id).to_sql
  end
end
