#-- encoding: UTF-8



module ProyeksiApp::TextFormatting::Formats
  module Markdown
    class Helper
      attr_reader :view_context

      def initialize(view_context)
        @view_context = view_context
      end

      def wikitoolbar_for(field_id, **context)
        # Hide the original textarea
        view_context.content_for(:additional_js_dom_ready) do
          js = <<-JAVASCRIPT
            var field = document.getElementById('#{field_id}');
            field.style.display = 'none';
            field.removeAttribute('required');
          JAVASCRIPT

          js.html_safe
        end

        # Pass an optional resource to the CKEditor instance
        resource = context.fetch(:resource, {})
        helpers.content_tag 'ckeditor-augmented-textarea',
                            '',
                            'textarea-selector': "##{field_id}",
                            'editor-type': context[:editor_type] || 'full',
                            'preview-context': context[:preview_context],
                            'data-resource': resource.to_json,
                            'macros': context.fetch(:macros, true)
      end

      protected

      def helpers
        ApplicationController.helpers
      end
    end
  end
end
