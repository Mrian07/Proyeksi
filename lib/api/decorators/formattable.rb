#-- encoding: UTF-8



module API
  module Decorators
    class Formattable < Single
      include OpenProject::TextFormatting

      def initialize(model, plain: false, object: nil)
        @format = if plain
                    OpenProject::TextFormatting::Formats.plain_format
                  else
                    OpenProject::TextFormatting::Formats.rich_format
                  end
        @object = object

        # Note: TextFormatting actually makes use of User.current, if it was possible to pass a
        # current_user explicitly, it would make sense to pass one here too.
        super(model, current_user: nil)
      end

      property :format,
               exec_context: :decorator,
               getter: ->(*) { @format },
               writable: false,
               render_nil: true
      property :raw,
               exec_context: :decorator,
               getter: ->(*) { represented },
               render_nil: true
      property :html,
               exec_context: :decorator,
               getter: ->(*) { to_html },
               writable: false,
               render_nil: true

      def to_html
        format_text(represented, format: @format, object: @object)
      end

      private

      def model_required?
        # the formatted string may also be nil, we are prepared for that
        false
      end
    end
  end
end
