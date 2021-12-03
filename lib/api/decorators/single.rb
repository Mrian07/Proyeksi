#-- encoding: UTF-8

require 'roar/decorator'
require 'roar/hypermedia'
require 'roar/json/hal'

require 'api/v3/utilities/path_helper'

module API
  module Decorators
    class Single < ::Roar::Decorator
      include ::Roar::JSON::HAL
      include ::Roar::Hypermedia
      include ::API::V3::Utilities::PathHelper

      attr_reader :current_user, :embed_links

      class_attribute :as_strategy
      self.as_strategy = ::API::Utilities::CamelCasingStrategy.new

      # Use this to create our own representers, giving them a chance to override the instantiation
      # if desired.
      def self.create(model, current_user:, embed_links: false)
        new(model, current_user: current_user, embed_links: embed_links)
      end

      def initialize(model, current_user:, embed_links: false)
        raise 'no represented object passed' if model_required? && model.nil?

        @current_user = current_user
        @embed_links = embed_links

        super(model)
      end

      property :_type,
               exec_context: :decorator,
               render_nil: false,
               writeable: false

      def self.self_link(path: nil, id_attribute: :id, title_getter: ->(*) { represented.name })
        link :self do
          self_path = self_v3_path(path, id_attribute)

          link_object = { href: self_path }
          title = instance_eval(&title_getter)
          link_object[:title] = title if title

          link_object
        end
      end

      class_attribute :to_eager_load
      class_attribute :checked_permissions

      def current_user_allowed_to(permission, context: represented.respond_to?(:project) ? represented.project : nil)
        current_user.allowed_to?(permission, context)
      end

      # Override in subclasses to specify the JSON indicated "_type" of this representer
      def _type; end

      def call_or_send_to_represented(callable_or_name)
        if callable_or_name.respond_to? :call
          instance_exec(&callable_or_name)
        else
          represented.send(callable_or_name)
        end
      end

      def call_or_use(callable_or_value)
        if callable_or_value.respond_to? :call
          instance_exec(&callable_or_value)
        else
          callable_or_value
        end
      end

      def datetime_formatter
        ::API::V3::Utilities::DateTimeFormatter
      end

      # If a subclass does not depend on a model being passed to this class, it can override
      # this method and return false. Otherwise it will be enforced that the model of each
      # representer is non-nil.
      def model_required?
        true
      end

      def self_v3_path(path, id_attribute)
        path ||= _type.underscore

        id = if id_attribute.respond_to?(:call)
               instance_eval(&id_attribute)
             else
               represented.send(id_attribute)
             end

        id = [nil] if id.nil?

        api_v3_paths.send(path, *Array(id))
      end
    end
  end
end
