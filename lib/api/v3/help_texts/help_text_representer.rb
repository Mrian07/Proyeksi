#-- encoding: UTF-8



module API
  module V3
    module HelpTexts
      class HelpTextRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Caching::CachedRepresenter
        include ::API::V3::Attachments::AttachableRepresenterMixin

        self_link path: :help_text,
                  id_attribute: :id,
                  title_getter: ->(*) { nil }

        link :editText do
          if current_user.admin? && represented.persisted?
            {
              href: edit_attribute_help_text_path(represented.id),
              type: 'text/html'
            }
          end
        end

        property :id
        property :attribute_name,
                 as: :attribute,
                 getter: ->(*) {
                   ::API::Utilities::PropertyNameConverter.from_ar_name(attribute_name)
                 }
        property :attribute_caption
        property :attribute_scope,
                 as: :scope
        property :help_text,
                 exec_context: :decorator,
                 getter: ->(*) {
                   ::API::Decorators::Formattable.new(represented.help_text)
                 }

        def _type
          'HelpText'
        end
      end
    end
  end
end
