#-- encoding: UTF-8

module API
  module V3
    module Versions
      class CreateFormRepresenter < FormRepresenter
        include API::Decorators::CreateForm
      end
    end
  end
end
