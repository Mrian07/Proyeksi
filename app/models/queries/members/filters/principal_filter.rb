#-- encoding: UTF-8

class Queries::Members::Filters::PrincipalFilter < Queries::Members::Filters::MemberFilter
  include Queries::Filters::Shared::MeValueFilter

  def allowed_values
    @allowed_values ||= begin
                          values = Principal
                                     .not_locked
                                     .in_visible_project_or_me
                                     .map { |s| [s.name, s.id.to_s] }
                                     .sort

                          me_allowed_value + values
                        end
  end

  def available?
    allowed_values.any?
  end

  def ar_object_filter?
    true
  end

  def principal_resource?
    true
  end

  def where
    operator_strategy.sql_for_field(values_replaced, self.class.model.table_name, :user_id)
  end

  def type
    :list_optional
  end

  def self.key
    :principal_id
  end
end
