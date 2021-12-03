module API
  module V3
    class ParseResourceParamsService < ::API::ParseResourceParamsService
      private

      def deduce_representer(model)
        "API::V3::#{model.to_s.pluralize}::#{model}PayloadRepresenter".constantize
      end

      def parsing_representer
        representer
          .create(struct, current_user: current_user)
      end

      def parse_attributes(request_body)
        super
          .except(:available_custom_fields)
      end

      def struct
        if model&.respond_to?(:available_custom_fields)
          OpenStruct.new available_custom_fields: model.available_custom_fields(model.new)
        else
          super
        end
      end
    end
  end
end
