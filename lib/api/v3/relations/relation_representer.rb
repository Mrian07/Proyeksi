#-- encoding: UTF-8

module API
  module V3
    module Relations
      class RelationRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource

        link :self do
          { href: api_v3_paths.relation(represented.id) }
        end

        link :updateImmediately do
          if manage_relations?
            { href: api_v3_paths.relation(represented.id), method: :patch }
          end
        end

        link :delete do
          if manage_relations?
            {
              href: api_v3_paths.relation(represented.id),
              method: :delete,
              title: 'Remove relation'
            }
          end
        end

        property :id

        property :name, exec_context: :decorator

        property :relation_type, as: :type

        property :reverse_type, as: :reverseType, exec_context: :decorator

        ##
        # The `delay` property is only used for the relation type "precedes/follows".
        property :delay,
                 render_nil: true,
                 if: ->(*) {
                   # the relation type may be blank when parsing for an update
                   [Relation::TYPE_FOLLOWS, Relation::TYPE_PRECEDES].include?(relation_type) ||
                     relation_type.blank?
                 }

        property :description, render_nil: true

        associated_resource :from,
                            v3_path: :work_package,
                            link_title_attribute: :subject,
                            representer: ::API::V3::WorkPackages::WorkPackageRepresenter

        associated_resource :to,
                            v3_path: :work_package,
                            link_title_attribute: :subject,
                            representer: ::API::V3::WorkPackages::WorkPackageRepresenter

        def _type
          @_type ||= "Relation"
        end

        def _type=(_type)
          # readonly
        end

        def name
          I18n.t "label_#{represented.relation_type}"
        end

        def name=(name)
          # readonly
        end

        def reverse_type
          represented.reverse_type
        end

        def reverse_type=(reverse_type)
          # readonly
        end

        def manage_relations?
          current_user_allowed_to :manage_work_package_relations, context: represented.from.project
        end

        self.to_eager_load = [:to,
                              { from: { project: :enabled_modules } }]
      end
    end
  end
end
