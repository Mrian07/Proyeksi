#-- encoding: UTF-8



module Grids::Configuration
  class WidgetStrategy
    class << self
      def after_destroy(proc = nil)
        if proc
          @after_destroy = proc
        end

        @after_destroy ||= -> {}
      end

      def allowed(proc = nil)
        if proc
          @allowed = proc
        end

        @allowed ||= ->(_user, _project) { true }
      end

      def allowed?(user, project)
        allowed.(user, project)
      end

      def options_representer(klass = nil)
        if klass
          @options_representer = klass
        end

        @options_representer || '::API::V3::Grids::Widgets::DefaultOptionsRepresenter'
      end
    end
  end
end
