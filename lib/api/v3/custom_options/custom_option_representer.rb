#-- encoding: UTF-8

module API
  module V3
    module CustomOptions
      class CustomOptionRepresenter < ::API::Decorators::Single
        self_link

        # TODO: add link to custom field once api for custom fields exists

        def _type
          'CustomOption'
        end

        property :id

        property :value
      end
    end
  end
end
