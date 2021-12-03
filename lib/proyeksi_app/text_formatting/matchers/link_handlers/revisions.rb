#-- encoding: UTF-8



module ProyeksiApp::TextFormatting::Matchers
  module LinkHandlers
    class Revisions < Base
      ##
      # Match revision links.
      # Condition: Separator is r
      # Condition: Prefix is nil
      def applicable?
        matcher.prefix.nil? && matcher.sep == 'r'
      end

      #
      # Examples:
      #
      # r11, r13
      def call
        # don't handle link unless repository exists
        return nil unless project && project.repository

        changeset = project.repository.find_changeset_by_name(matcher.identifier)

        if changeset
          link_to(h("#{matcher.project_prefix}r#{matcher.identifier}"),
                  { only_path: context[:only_path], controller: '/repositories', action: 'revision', project_id: project,
                    rev: changeset.revision },
                  class: 'changeset',
                  title: truncate_single_line(changeset.comments, length: 100))
        end
      end
    end
  end
end
