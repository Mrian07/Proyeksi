#-- encoding: UTF-8

class Queries::Projects::Filters::PublicFilter < Queries::Projects::Filters::ProjectFilter
  include Queries::Filters::Shared::BooleanFilter

  def self.key
    :public
  end
end
