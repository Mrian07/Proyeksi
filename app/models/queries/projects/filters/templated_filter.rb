#-- encoding: UTF-8

class Queries::Projects::Filters::TemplatedFilter < Queries::Projects::Filters::ProjectFilter
  include Queries::Filters::Shared::BooleanFilter

  def self.key
    :templated
  end
end
