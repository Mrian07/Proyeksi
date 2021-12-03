#-- encoding: UTF-8

module API
  module Decorators
    module CreateForm
      def form_url
        api_v3_paths.send(:"create_#{downcase_model_name}_form")
      end

      def resource_url
        api_v3_paths.send(downcase_model_name.pluralize)
      end

      def commit_method
        :post
      end

      def contract_class
        "::#{model_name.pluralize}::CreateContract".constantize
      end

      private

      def downcase_model_name
        model_name.underscore
      end
    end
  end
end
