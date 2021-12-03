#-- encoding: UTF-8

class Queries::WorkPackages::Filter::PrincipalBaseFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  include Queries::WorkPackages::Filter::MeValueFilterMixin

  def allowed_values
    @allowed_values ||= begin
                          me_allowed_value + principal_loader.principal_values
                        end
  end

  def available?
    User.current.logged? || allowed_values.any?
  end

  def ar_object_filter?
    true
  end

  def principal_resource?
    true
  end

  def where
    operator_strategy.sql_for_field(values_replaced, self.class.model.table_name, self.class.key)
  end

  private

  def principal_loader
    @principal_loader ||= ::Queries::WorkPackages::Filter::PrincipalLoader.new(project)
  end
end
