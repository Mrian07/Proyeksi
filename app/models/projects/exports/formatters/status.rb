#-- encoding: UTF-8

module Projects::Exports
  module Formatters
    class Status < ::Exports::Formatters::Default
      def self.apply?(attribute)
        %i[project_status status].include?(attribute.to_sym)
      end

      ##
      # Takes a project and returns the localized status code
      def format(project, **)
        code = project.status&.code
        return '' unless code

        translate_code code
      end

      private

      def translate_code(enum_name)
        I18n.t("activerecord.attributes.projects/status.codes.#{enum_name}")
      end
    end
  end
end
