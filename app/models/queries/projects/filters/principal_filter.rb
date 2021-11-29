#-- encoding: UTF-8



class Queries::Projects::Filters::PrincipalFilter < Queries::Projects::Filters::ProjectFilter
  def type
    :list_optional
  end

  def allowed_values
    @allowed_values ||= begin
      ::Principal.pluck(:id).map { |id| [id, id.to_s] }
    end
  end

  def scope
    super.includes(:memberships).references(:members)
  end

  def where
    operator_strategy.sql_for_field(values, 'members', 'user_id')
  end
end
