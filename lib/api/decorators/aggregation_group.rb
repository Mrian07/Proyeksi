#-- encoding: UTF-8



module API
  module Decorators
    class AggregationGroup < Single
      def initialize(group_key, count, query:, current_user:)
        @count = count
        @query = query

        if group_key.is_a?(Array)
          group_key = set_links!(group_key)
        end

        @link = ::API::V3::Utilities::ResourceLinkGenerator.make_link(group_key)

        super(group_key, current_user: current_user)
      end

      links :valueLink do
        if @links
          @links
        elsif @link
          [{ href: @link }]
        else
          []
        end
      end

      property :value,
               exec_context: :decorator,
               render_nil: true

      property :count,
               exec_context: :decorator,
               getter: ->(*) { count },
               render_nil: true

      def model_required?
        false
      end

      attr_reader :count,
                  :query

      ##
      # Initializes the links collection for this group if the group has multiple keys
      #
      # @return [String] A new group key for the multi value custom field.
      def set_links!(group_key)
        @links = group_key.map do |opt|
          {
            href: ::API::V3::Utilities::ResourceLinkGenerator.make_link(opt),
            title: opt.to_s
          }
        end

        if group_key.present?
          group_key.map(&:name).sort.join(", ")
        end
      end

      def value
        if represented == true || represented == false
          represented
        else
          represented ? represented.to_s : nil
        end
      end

      def convert_attribute(attribute)
        ::API::Utilities::PropertyNameConverter.from_ar_name(attribute)
      end
    end
  end
end
