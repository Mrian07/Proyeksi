#-- encoding: UTF-8



module ProyeksiApp::TextFormatting::Matchers
  module LinkHandlers
    class WorkPackages < Base
      ##
      # Match work package links.
      # Condition: Separator is #|##|###
      # Condition: Prefix is nil
      def applicable?
        %w(# ## ###).include?(matcher.sep) && matcher.prefix.nil?
      end

      #
      # Examples:
      #
      # #1234, ##1234, ###1234
      def call
        wp_id = matcher.identifier.to_i

        # Ensure that the element was entered numeric,
        # prohibits links to things like #0123
        return if wp_id.to_s != matcher.identifier

        if matcher.sep == '##' || matcher.sep == '###'
          render_work_package_macro(wp_id, detailed: (matcher.sep === '###'))
        else
          render_work_package_link(wp_id)
        end
      end

      private

      def render_work_package_macro(wp_id, detailed: false)
        ApplicationController.helpers.content_tag :macro,
                                                  '',
                                                  class: "macro--wp-quickinfo",
                                                  data: { id: wp_id, detailed: detailed }
      end

      def render_work_package_link(wp_id)
        link_to("##{wp_id}",
                work_package_path_or_url(id: wp_id, only_path: context[:only_path]),
                class: 'issue work_package preview-trigger')
      end
    end
  end
end
