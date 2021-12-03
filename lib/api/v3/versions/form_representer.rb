#-- encoding: UTF-8

module API
  module V3
    module Versions
      class FormRepresenter < ::API::Decorators::SimpleForm
        def model
          Version
        end
      end
    end
  end
end
