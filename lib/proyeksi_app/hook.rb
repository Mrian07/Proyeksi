#-- encoding: UTF-8



module ProyeksiApp
  module Hook
    class << self
      # Adds a listener class.
      # Automatically called when a class inherits from ProyeksiApp::Hook::Listener.
      def add_listener(klass)
        raise ArgumentError, 'Hooks must include Singleton module.' unless klass.included_modules.include?(Singleton)

        listener_classes << klass
        clear_listeners_instances
      end

      # Returns all the listener instances.
      def listeners
        @listeners ||= listener_classes.map(&:instance)
      end

      def listener_classes
        @listener_classes ||= []
      end

      # Returns the listener instances for the given hook.
      def hook_listeners(hook)
        @hook_listeners ||= {}
        @hook_listeners[hook] ||= listeners.select { |listener| listener.respond_to?(hook) }
      end

      # Clears all the listeners.
      def clear_listeners
        @listener_classes = []
        clear_listeners_instances
      end

      # Clears all the listeners instances.
      def clear_listeners_instances
        @listeners = nil
        @hook_listeners = {}
      end

      # Calls a hook.
      # Returns the listeners response.
      def call_hook(hook, context = {})
        [].tap do |response|
          hook_listeners(hook).each do |listener|
            response << listener.send(hook, context)
          rescue StandardError => e
            msg = "Failed to collect hook response for #{hook} from #{listener.inspect}"
            ::ProyeksiApp.logger.error(msg, exception: e, extra: { hook_name: hook })
          end
        end
      end
    end

    # Base class for hook listeners.
    class Listener
      include Singleton
      include Redmine::I18n

      # Registers the listener
      def self.inherited(child)
        ProyeksiApp::Hook.add_listener(child)
        super
      end
    end

    # Listener class used for views hooks.
    # Listeners that inherit this class will include various helpers by default.
    class ViewListener < Listener
      include ERB::Util
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::FormTagHelper
      include ActionView::Helpers::FormOptionsHelper
      include ActionView::Helpers::JavaScriptHelper
      include ActionView::Helpers::NumberHelper
      include ActionView::Helpers::UrlHelper
      include Sprockets::Rails::Helper
      include ActionView::Helpers::TextHelper
      include Rails.application.routes.url_helpers
      include ApplicationHelper

      # Default to creating links using only the path.  Subclasses can
      # change this default as needed
      def self.default_url_options
        {
          host: ProyeksiApp::StaticRouting::UrlHelpers.host,
          only_path: true,
          script_name: ProyeksiApp::Configuration.rails_relative_url_root
        }
      end

      # Helper method to directly render a partial using the context:
      #
      #   class MyHook < ProyeksiApp::Hook::ViewListener
      #     render_on :view_issues_show_details_bottom, partial: "show_more_data"
      #   end
      #
      def self.render_on(hook, options = {})
        define_method hook do |context|
          if context[:hook_caller].respond_to?(:render)
            context[:hook_caller].send(:render, { locals: context }.merge(options))
          elsif context[:controller].is_a?(ActionController::Base)
            context[:controller].send(:render_to_string, { locals: context }.merge(options))
          else
            raise "Cannot render #{name} hook from #{context[:hook_caller].class.name}"
          end
        end
      end

      def controller
        nil
      end

      def config
        ActionController::Base.config
      end
    end
  end
end
