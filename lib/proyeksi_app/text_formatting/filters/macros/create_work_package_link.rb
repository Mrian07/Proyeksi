#-- encoding: UTF-8



module ProyeksiApp::TextFormatting::Filters::Macros
  module CreateWorkPackageLink
    class << self
      include ProyeksiApp::StaticRouting::UrlHelpers
    end

    HTML_CLASS = 'create_work_package_link'.freeze

    module_function

    def identifier
      HTML_CLASS
    end

    def apply(macro, result:, context:)
      macro.replace work_package_link(macro, context)
    end

    def work_package_link(macro, context)
      project = context[:project]
      raise I18n.t('macros.create_work_package_link.errors.no_project_context') if project.nil?

      type_name = macro['data-type']
      class_name = macro['data-classes'] == 'button' ? 'button' : nil

      if type_name.present?
        type = project.types.find_by(name: type_name)
        if type.nil?
          raise I18n.t(
            'macros.create_work_package_link.errors.invalid_type',
            type: type_name,
            project: project.name
          )
        end

        ApplicationController.helpers.link_to(
          I18n.t('macros.create_work_package_link.link_name_type', type_name: type_name),
          new_project_work_packages_path(project_id: project.identifier, type: type.id),
          class: class_name
        )
      else
        ApplicationController.helpers.link_to(
          I18n.t('macros.create_work_package_link.link_name'),
          new_project_work_packages_path(project_id: project.identifier),
          class: class_name
        )
      end
    end
  end
end
