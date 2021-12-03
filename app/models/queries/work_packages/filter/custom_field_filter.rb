#-- encoding: UTF-8

class Queries::WorkPackages::Filter::CustomFieldFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  include Queries::Filters::Shared::CustomFieldFilter
  self.custom_field_context = ::Queries::WorkPackages::Filter::CustomFieldContext
end
