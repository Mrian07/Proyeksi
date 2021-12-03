#-- encoding: UTF-8

module API
  module Decorators
    module UpdateForm
      def form_url
        api_v3_paths.send(:"#{downcase_model_name}_form", represented.id)
      end

      def resource_url
        api_v3_paths.send(downcase_model_name, represented.id)
      end

      def commit_method
        :patch
      end

      def contract_class
        "::#{model_name.pluralize}::UpdateContract".constantize
      end

      private

      def downcase_model_name
        model_name.underscore
      end
    end
  end
end
