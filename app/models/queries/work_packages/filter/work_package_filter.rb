#-- encoding: UTF-8

class Queries::WorkPackages::Filter::WorkPackageFilter < ::Queries::Filters::Base
  include ::Queries::Filters::Serializable

  self.model = WorkPackage

  def human_name
    WorkPackage.human_attribute_name(name)
  end

  def project
    context.project
  end

  def includes
    nil
  end

  def scope
    # We only return the WorkPackage base scope for now as most of the filters
    # (this one's subclasses) currently do not follow the base filter approach of using the scope.
    # The intend is to have more and more wp filters use the scope method just like the
    # rest of the queries (e.g. project)
    WorkPackage.unscoped
  end
end
