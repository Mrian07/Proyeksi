#-- encoding: UTF-8

module API
  module V3
    module CustomActions
      class CustomActionRepresenter < ::API::Decorators::Single
        link :executeImmediately do
          {
            href: api_v3_paths.custom_action_execute(represented.id),
            title: I18n.t('custom_actions.execute', name: represented.name),
            method: 'post'
          }
        end

        self_link

        property :name
        property :description,
                 render_nil: true

        def _type
          'CustomAction'
        end
      end
    end
  end
end
