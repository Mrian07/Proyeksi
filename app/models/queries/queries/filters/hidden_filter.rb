#-- encoding: UTF-8



class Queries::Queries::Filters::HiddenFilter < Queries::Queries::Filters::QueryFilter
  include Queries::Filters::Shared::BooleanFilter

  def self.key
    :hidden
  end
end
