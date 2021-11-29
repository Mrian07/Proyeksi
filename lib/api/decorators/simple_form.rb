#-- encoding: UTF-8



module API
  module Decorators
    class SimpleForm < ::API::Decorators::Form
      link :self do
        {
          href: form_url,
          method: :post
        }
      end

      link :validate do
        {
          href: form_url,
          method: :post
        }
      end

      link :commit do
        next unless @errors.empty?

        {
          href: resource_url,
          method: commit_method
        }
      end

      def commit_method
        raise NotImplementedError, "subclass responsibility"
      end

      def form_url
        raise NotImplementedError, "subclass responsibility"
      end

      def resource_url
        raise NotImplementedError, "subclass responsibility"
      end

      def payload_representer
        payload_representer_class
          .create(represented, current_user: current_user)
      end

      def schema_representer
        contract = contract_class.new(represented, current_user)

        schema_representer_class
          .create(contract,
                  form_embedded: true,
                  current_user: current_user)
      end

      def contract_class
        raise NotImplementedError, "subclass responsibility"
      end

      def model
        raise NotImplementedError, "subclass responsibility"
      end

      private

      def model_name
        model.name.demodulize
      end

      def payload_representer_class
        "API::V3::#{model_name.pluralize}::#{model_name}PayloadRepresenter"
          .constantize
      end

      def schema_representer_class
        "API::V3::#{model_name.pluralize}::Schemas::#{model_name}SchemaRepresenter"
          .constantize
      end
    end
  end
end
