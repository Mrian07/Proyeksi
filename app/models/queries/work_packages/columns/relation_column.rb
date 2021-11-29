#-- encoding: UTF-8



class Queries::WorkPackages::Columns::RelationColumn < Queries::WorkPackages::Columns::WorkPackageColumn
  attr_accessor :type

  def self.granted_by_enterprise_token
    EnterpriseToken.allows_to?(:work_package_query_relation_columns)
  end

  private_class_method :granted_by_enterprise_token
end
