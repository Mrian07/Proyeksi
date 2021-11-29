#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      class WorkPackageRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Decorators::DateProperty
        include API::Decorators::FormattableProperty
        include API::Caching::CachedRepresenter
        include ::API::V3::Attachments::AttachableRepresenterMixin
        extend ::API::V3::Utilities::CustomFieldInjector::RepresenterClass

        cached_representer key_parts: %i(project),
                           disabled: false

        def initialize(model, current_user:, embed_links: false)
          model = load_complete_model(model)

          super
        end

        self_link title_getter: ->(*) { represented.subject }

        link :update,
             cache_if: -> { current_user_update_allowed? } do
          {
            href: api_v3_paths.work_package_form(represented.id),
            method: :post
          }
        end

        link :schema do
          {
            href: api_v3_paths.work_package_schema(represented.project_id, represented.type_id)
          }
        end

        link :updateImmediately,
             cache_if: -> { current_user_update_allowed? } do
          {
            href: api_v3_paths.work_package(represented.id),
            method: :patch
          }
        end

        link :delete,
             cache_if: -> { current_user_allowed_to(:delete_work_packages, context: represented.project) } do
          {
            href: api_v3_paths.work_package(represented.id),
            method: :delete
          }
        end

        link :logTime,
             cache_if: -> { current_user_allowed_to(:log_time, context: represented.project) } do
          next if represented.new_record?

          {
            href: api_v3_paths.time_entries,
            title: "Log time on #{represented.subject}"
          }
        end

        link :move,
             cache_if: -> { current_user_allowed_to(:move_work_packages, context: represented.project) } do
          next if represented.new_record?

          {
            href: new_work_package_move_path(represented),
            type: 'text/html',
            title: "Move #{represented.subject}"
          }
        end

        link :copy,
             cache_if: -> { current_user_allowed_to(:add_work_packages, context: represented.project) } do
          next if represented.new_record?

          {
            href: work_package_path(represented, 'copy'),
            title: "Copy #{represented.subject}"
          }
        end

        link :pdf,
             cache_if: -> { current_user_allowed_to(:export_work_packages, context: represented.project) } do
          next if represented.new_record?

          {
            href: work_package_path(id: represented.id, format: :pdf),
            type: 'application/pdf',
            title: 'Export as PDF'
          }
        end

        link :atom,
             cache_if: -> { current_user_allowed_to(:export_work_packages, context: represented.project) } do
          next if represented.new_record? || !Setting.feeds_enabled?

          {
            href: work_package_path(id: represented.id, format: :atom),
            type: 'application/rss+xml',
            title: 'Atom feed'
          }
        end

        link :availableRelationCandidates do
          next if represented.new_record?

          {
            href: api_v3_paths.work_package_available_relation_candidates(represented.id),
            title: "Potential work packages to relate to"
          }
        end

        link :customFields,
             cache_if: -> { current_user_allowed_to(:select_custom_fields, context: represented.project) } do
          next if represented.project.nil?

          {
            href: project_settings_custom_fields_path(represented.project.identifier),
            type: 'text/html',
            title: "Custom fields"
          }
        end

        link :configureForm,
             cache_if: -> { current_user.admin? } do
          next unless represented.type_id

          {
            href: edit_type_path(represented.type_id, tab: 'form_configuration'),
            type: 'text/html',
            title: "Configure form"
          }
        end

        link :activities do
          {
            href: api_v3_paths.work_package_activities(represented.id)
          }
        end

        link :availableWatchers,
             cache_if: -> { current_user_allowed_to(:add_work_package_watchers, context: represented.project) } do
          {
            href: api_v3_paths.available_watchers(represented.id)
          }
        end

        link :relations do
          {
            href: api_v3_paths.work_package_relations(represented.id)
          }
        end

        link :revisions do
          {
            href: api_v3_paths.work_package_revisions(represented.id)
          }
        end

        link :watch,
             uncacheable: true do
          next if current_user.anonymous? || current_user_watcher?

          {
            href: api_v3_paths.work_package_watchers(represented.id),
            method: :post,
            payload: { user: { href: api_v3_paths.user(current_user.id) } }
          }
        end

        link :unwatch,
             uncacheable: true do
          next unless current_user_watcher?

          {
            href: api_v3_paths.watcher(current_user.id, represented.id),
            method: :delete
          }
        end

        link :watchers,
             cache_if: -> { current_user_allowed_to(:view_work_package_watchers, context: represented.project) } do
          {
            href: api_v3_paths.work_package_watchers(represented.id)
          }
        end

        link :addWatcher,
             cache_if: -> { current_user_allowed_to(:add_work_package_watchers, context: represented.project) } do
          {
            href: api_v3_paths.work_package_watchers(represented.id),
            method: :post,
            payload: { user: { href: api_v3_paths.user('{user_id}') } },
            templated: true
          }
        end

        link :removeWatcher,
             cache_if: -> { current_user_allowed_to(:delete_work_package_watchers, context: represented.project) } do
          {
            href: api_v3_paths.watcher('{user_id}', represented.id),
            method: :delete,
            templated: true
          }
        end

        link :addRelation,
             cache_if: -> { current_user_allowed_to(:manage_work_package_relations, context: represented.project) } do
          {
            href: api_v3_paths.work_package_relations(represented.id),
            method: :post,
            title: 'Add relation'
          }
        end

        link :addChild,
             cache_if: -> { current_user_allowed_to(:add_work_packages, context: represented.project) } do
          next if represented.milestone? || represented.new_record?

          {
            href: api_v3_paths.work_packages_by_project(represented.project.identifier),
            method: :post,
            title: "Add child of #{represented.subject}"
          }
        end

        link :changeParent,
             cache_if: -> { current_user_allowed_to(:manage_subtasks, context: represented.project) } do
          {
            href: api_v3_paths.work_package(represented.id),
            method: :patch,
            title: "Change parent of #{represented.subject}"
          }
        end

        link :addComment,
             cache_if: -> { current_user_allowed_to(:add_work_package_notes, context: represented.project) } do
          {
            href: api_v3_paths.work_package_activities(represented.id),
            method: :post,
            title: 'Add comment'
          }
        end

        link :previewMarkup do
          {
            href: api_v3_paths.render_markup(link: api_v3_paths.work_package(represented.id)),
            method: :post
          }
        end

        link :timeEntries,
             cache_if: -> { view_time_entries_allowed? } do
          next if represented.new_record?

          filters = [{ work_package_id: { operator: "=", values: [represented.id.to_s] } }]

          {
            href: api_v3_paths.path_for(:time_entries, filters: filters),
            title: 'Time entries'
          }
        end

        links :children,
              uncacheable: true do
          next if visible_children.empty?

          visible_children.map do |child|
            {
              href: api_v3_paths.work_package(child.id),
              title: child.subject
            }
          end
        end

        links :ancestors,
              uncacheable: true do
          represented.visible_ancestors(current_user).map do |ancestor|
            {
              href: api_v3_paths.work_package(ancestor.id),
              title: ancestor.subject
            }
          end
        end

        property :id,
                 render_nil: true

        property :lock_version,
                 render_nil: true,
                 getter: ->(*) {
                   lock_version.to_i
                 }

        property :subject,
                 render_nil: true

        formattable_property :description

        property :schedule_manually,
                 exec_context: :decorator,
                 getter: ->(*) { represented.schedule_manually? }

        date_property :start_date,
                      skip_render: ->(represented:, **) {
                        represented.milestone?
                      }

        date_property :due_date,
                      skip_render: ->(represented:, **) {
                        represented.milestone?
                      }

        # Using setter: does not work in case the provided date fragment is nil.
        date_property :date,
                      getter: default_date_getter(:due_date),
                      setter: ->(*) {
                        # handled in reader
                      },
                      reader: ->(decorator:, doc:, **) {
                        next unless doc.key?('date')

                        date = decorator
                               .datetime_formatter
                               .parse_date(doc['date'],
                                           name.to_s.camelize(:lower),
                                           allow_nil: true)

                        self.due_date = self.start_date = date
                      },
                      skip_render: ->(represented:, **) {
                        !represented.milestone?
                      }

        date_property :derived_start_date,
                      skip_render: ->(represented:, **) {
                        represented.milestone?
                      },
                      uncacheable: true

        date_property :derived_due_date,
                      skip_render: ->(represented:, **) {
                        represented.milestone?
                      },
                      uncacheable: true

        property :estimated_time,
                 exec_context: :decorator,
                 getter: ->(*) do
                   datetime_formatter.format_duration_from_hours(represented.estimated_hours,
                                                                 allow_nil: true)
                 end,
                 render_nil: true

        property :derived_estimated_time,
                 exec_context: :decorator,
                 getter: ->(*) do
                   datetime_formatter.format_duration_from_hours(represented.derived_estimated_hours,
                                                                 allow_nil: true)
                 end,
                 render_nil: true

        property :spent_time,
                 exec_context: :decorator,
                 getter: ->(*) do
                   datetime_formatter.format_duration_from_hours(represented.spent_hours)
                 end,
                 if: ->(*) {
                   view_time_entries_allowed?
                 },
                 uncacheable: true

        property :done_ratio,
                 as: :percentageDone,
                 render_nil: true,
                 if: ->(*) { Setting.work_package_done_ratio != 'disabled' }

        date_time_property :created_at

        date_time_property :updated_at

        property :relations,
                 embedded: true,
                 exec_context: :decorator,
                 if: ->(*) { embed_links },
                 uncacheable: true

        associated_resource :category

        associated_resource :type

        associated_resource :priority

        associated_resource :project

        associated_resource :status

        associated_resource :author,
                            v3_path: :user,
                            representer: ::API::V3::Users::UserRepresenter

        associated_resource :responsible,
                            getter: ::API::V3::Principals::PrincipalRepresenterFactory
                                      .create_getter_lambda(:responsible),
                            setter: PrincipalSetter.lambda(:responsible),
                            link: ::API::V3::Principals::PrincipalRepresenterFactory
                                    .create_link_lambda(:responsible)

        associated_resource :assignee,
                            getter: ::API::V3::Principals::PrincipalRepresenterFactory
                                      .create_getter_lambda(:assigned_to),
                            setter: PrincipalSetter.lambda(:assigned_to, :assignee),
                            link: ::API::V3::Principals::PrincipalRepresenterFactory
                                    .create_link_lambda(:assigned_to)

        associated_resource :version,
                            v3_path: :version,
                            representer: ::API::V3::Versions::VersionRepresenter

        associated_resource :parent,
                            v3_path: :work_package,
                            representer: ::API::V3::WorkPackages::WorkPackageRepresenter,
                            skip_render: ->(*) { represented.parent && !represented.parent.visible? },
                            link_title_attribute: :subject,
                            uncacheable_link: true,
                            link: ->(*) {
                              if represented.parent&.visible?
                                {
                                  href: api_v3_paths.work_package(represented.parent.id),
                                  title: represented.parent.subject
                                }
                              else
                                {
                                  href: nil,
                                  title: nil
                                }
                              end
                            },
                            setter: ->(fragment:, **) do
                              next if fragment.empty?

                              href = fragment['href']

                              new_parent = if href
                                             id = ::API::Utilities::ResourceLinkParser
                                                  .parse_id href,
                                                            property: 'parent',
                                                            expected_version: '3',
                                                            expected_namespace: 'work_packages'

                                             WorkPackage.find_by(id: id) ||
                                               ::WorkPackage::InexistentWorkPackage.new(id: id)
                                           end

                              represented.parent = new_parent
                            end

        associated_resource :budget,
                            as: :budget,
                            v3_path: :budget,
                            link_title_attribute: :subject,
                            representer: ::API::V3::Budgets::BudgetRepresenter,
                            skip_render: ->(*) { !view_budgets_allowed? }

        resources :customActions,
                  uncacheable_link: true,
                  link: ->(*) {
                    ordered_custom_actions.map do |action|
                      {
                        href: api_v3_paths.custom_action(action.id),
                        title: action.name
                      }
                    end
                  },
                  getter: ->(*) {
                    ordered_custom_actions.map do |action|
                      ::API::V3::CustomActions::CustomActionRepresenter.new(action, current_user: current_user)
                    end
                  },
                  setter: ->(*) do
                    # noop
                  end

        def _type
          'WorkPackage'
        end

        def to_hash(*args)
          # Define all accessors on the customizable as they
          # will be used afterwards anyway. Otherwise, we will have to
          # go through method_missing which will take more time.
          represented.define_all_custom_field_accessors

          super
        end

        def current_user_watcher?
          represented.watchers.any? { |w| w.user_id == current_user.id }
        end

        def current_user_update_allowed?
          current_user_allowed_to(:edit_work_packages, context: represented.project) ||
            current_user_allowed_to(:assign_versions, context: represented.project)
        end

        def relations
          self_path = api_v3_paths.work_package_relations(represented.id)
          visible_relations = represented
                              .visible_relations(current_user)
                              .direct
                              .non_hierarchy
                              .includes(::API::V3::Relations::RelationCollectionRepresenter.to_eager_load)

          ::API::V3::Relations::RelationCollectionRepresenter.new(visible_relations,
                                                                  self_link: self_path,
                                                                  current_user: current_user)
        end

        def visible_children
          @visible_children ||= represented.children.select(&:visible?)
        end

        def schedule_manually=(value)
          represented.schedule_manually = value
        end

        def estimated_time=(value)
          represented.estimated_hours = datetime_formatter.parse_duration_to_hours(value,
                                                                                   'estimatedTime',
                                                                                   allow_nil: true)
        end

        def derived_estimated_time=(value)
          represented.derived_estimated_hours = datetime_formatter
            .parse_duration_to_hours(value, 'derivedEstimatedTime', allow_nil: true)
        end

        def spent_time=(value)
          # noop
        end

        def ordered_custom_actions
          # As the custom actions are sometimes set as an array
          represented.custom_actions(current_user).to_a.sort_by(&:position)
        end

        # Attachments need to be eager loaded for the description
        self.to_eager_load = %i[parent
                                type
                                watchers
                                attachments
                                budget]

        # The dynamic class generation introduced because of the custom fields interferes with
        # the class naming as well as prevents calls to super
        def json_cache_key
          ['API',
           'V3',
           'WorkPackages',
           'WorkPackageRepresenter',
           'json',
           I18n.locale,
           json_key_representer_parts,
           represented.cache_checksum,
           Setting.work_package_done_ratio,
           Setting.feeds_enabled?]
        end

        def view_time_entries_allowed?
          current_user_allowed_to(:view_time_entries, context: represented.project) ||
            current_user_allowed_to(:view_own_time_entries, context: represented.project)
        end

        def view_budgets_allowed?
          current_user_allowed_to(:view_budgets, context: represented.project)
        end

        def load_complete_model(model)
          ::API::V3::WorkPackages::WorkPackageEagerLoadingWrapper.wrap_one(model, current_user)
        end
      end
    end
  end
end