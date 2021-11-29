#-- encoding: UTF-8



require_relative 'base'

module Queries::Filters::Shared
  module CustomFields
    class Bool < Base
      include Queries::Filters::Shared::BooleanFilter
    end
  end
end
