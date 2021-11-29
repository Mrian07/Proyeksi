#-- encoding: UTF-8



module API
  module Decorators
    class LinkObject < Single
      def initialize(model,
                     property_name:,
                     path: :"#{property_name}",
                     namespace: path.to_s.pluralize,
                     title_attribute: :name,
                     getter: :"#{property_name}_id",
                     setter: :"#{getter}=")
        @property_name = property_name
        @path = path
        @namespace = namespace
        @getter = getter
        @setter = setter
        @title_attribute = title_attribute

        super(model, current_user: nil)
      end

      property :href,
               exec_context: :decorator,
               render_nil: true

      property :title,
               exec_context: :decorator,
               writeable: false,
               render_nil: false

      def href
        id = represented.send(@getter) if represented

        return nil if id.nil? || id.zero?

        api_v3_paths.send(@path, id)
      end

      def href=(value)
        # Ignore linked resources that are hidden to the client
        # See lib/api/v3.rb for more details.
        return if value == API::V3::URN_UNDISCLOSED

        id = if value
               ::API::Utilities::ResourceLinkParser.parse_id value,
                                                             property: @property_name,
                                                             expected_version: '3',
                                                             expected_namespace: @namespace
             end

        represented.send(@setter, id)
      end

      def title
        attribute = ::API::Utilities::PropertyNameConverter.to_ar_name(
          @property_name,
          context: represented
        )

        represented.try(attribute).try(@title_attribute)
      end
    end
  end
end
