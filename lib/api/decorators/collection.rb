#-- encoding: UTF-8



module API
  module Decorators
    class Collection < ::API::Decorators::Single
      include API::Utilities::UrlHelper

      def initialize(models, total, self_link:, current_user:, groups: nil)
        @total = total
        @groups = groups
        @self_link = self_link

        super(models, current_user: current_user)
      end

      class_attribute :element_decorator_class

      def self.element_decorator(klass)
        self.element_decorator_class = klass
      end

      def element_decorator
        self.class.element_decorator_class || deduce_element_decorator
      end

      def deduce_element_decorator
        name = self.class.name

        unless name.end_with?('CollectionRepresenter')
          raise ArgumentError, "Can't deduce representer name from #{name}, please specify it with `element_decorator ClassName`"
        end

        name
          .gsub("CollectionRepresenter", "Representer")
          .constantize
      end

      link :self do
        { href: @self_link }
      end

      property :total, getter: ->(*) { @total }, exec_context: :decorator
      property :count, getter: ->(*) { count }

      property :groups,
               exec_context: :decorator,
               render_nil: false

      collection :elements,
                 getter: ->(*) {
                   represented.map do |model|
                     element_decorator.create(model, current_user: current_user)
                   end
                 },
                 exec_context: :decorator,
                 embedded: true

      def _type
        'Collection'
      end

      attr_reader :groups
    end
  end
end
