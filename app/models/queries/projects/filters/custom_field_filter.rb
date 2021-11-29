#-- encoding: UTF-8



class Queries::Projects::Filters::CustomFieldFilter <
  Queries::Projects::Filters::ProjectFilter
  include Queries::Filters::Shared::CustomFieldFilter
  self.custom_field_context = ::Queries::Projects::Filters::CustomFieldContext
end
