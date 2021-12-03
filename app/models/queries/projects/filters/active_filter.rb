#-- encoding: UTF-8

class Queries::Projects::Filters::ActiveFilter < Queries::Projects::Filters::ProjectFilter
  include Queries::Filters::Shared::BooleanFilter

  def self.key
    :active
  end
end
