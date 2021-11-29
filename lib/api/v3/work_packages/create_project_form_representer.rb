#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      class CreateProjectFormRepresenter < FormRepresenter
        link :self do
          {
            href: api_v3_paths.create_project_work_package_form(represented.project_id),
            method: :post
          }
        end

        link :validate do
          {
            href: api_v3_paths.create_project_work_package_form(represented.project_id),
            method: :post
          }
        end

        link :previewMarkup do
          {
            href: api_v3_paths.render_markup(link: api_v3_paths.project(represented.project_id)),
            method: :post
          }
        end

        link :commit do
          if current_user
             .allowed_to?(:edit_work_packages, represented.project) &&
             @errors.empty?
            {
              href: api_v3_paths.work_packages_by_project(represented.project_id),
              method: :post
            }
          end
        end

        link :customFields do
          if current_user_allowed_to(:select_custom_fields,
                                     context: represented.project)
            {
              href: project_settings_custom_fields_path(represented.project.identifier),
              type: 'text/html',
              title: I18n.t('label_custom_field_plural')
            }
          end
        end

        link :configureForm do
          if current_user.admin? &&
             represented.type_id &&
             represented.type_id != 0
            {
              href: edit_type_path(represented.type_id,
                                   tab: 'form_configuration'),
              type: 'text/html',
              title: "Configure form"
            }
          end
        end
      end
    end
  end
end
