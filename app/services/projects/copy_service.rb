#-- encoding: UTF-8



module Projects
  class CopyService < ::BaseServices::Copy
    include Projects::Concerns::NewProjectService

    def self.copy_dependencies
      [
        ::Projects::Copy::MembersDependentService,
        ::Projects::Copy::VersionsDependentService,
        ::Projects::Copy::CategoriesDependentService,
        ::Projects::Copy::WorkPackagesDependentService,
        ::Projects::Copy::WorkPackageAttachmentsDependentService,
        ::Projects::Copy::WikiDependentService,
        ::Projects::Copy::WikiPageAttachmentsDependentService,
        ::Projects::Copy::ForumsDependentService,
        ::Projects::Copy::QueriesDependentService,
        ::Projects::Copy::BoardsDependentService,
        ::Projects::Copy::OverviewDependentService
      ]
    end

    ##
    # In case a rollback is needed,
    # destroy the copied project again.
    def rollback
      state.project&.destroy
    end

    protected

    ##
    # Whether to skip the given key.
    # Useful when copying nested dependencies
    def skip_dependency?(params, dependency_cls)
      !Copy::Dependency.should_copy?(params, dependency_cls.identifier.to_sym)
    end

    def initialize_copy(source, params)
      target = Project.new

      target.attributes = source.attributes.dup.except(*skipped_attributes)
      # Clear enabled modules
      target.enabled_modules = []
      target.enabled_module_names = source.enabled_module_names - %w[repository]
      target.types = source.types
      target.work_package_custom_fields = source.work_package_custom_fields

      # Copy status object
      target.status = source.status&.dup

      # Take over the CF values for attributes
      target.custom_field_values = source.custom_value_attributes

      # Additional input target params
      target_project_params = params[:target_project_params].with_indifferent_access

      cleanup_target_project_params(source, target, target_project_params)
      cleanup_target_project_attributes(source, target, target_project_params)

      # Assign additional params from user
      call = Projects::SetAttributesService
        .new(user: user,
             model: target,
             contract_class: Projects::CopyContract,
             contract_options: { copy_source: source, validate_model: true })
        .with_state(state)
        .call(target_project_params)

      # Retain values after the set attributes service
      retain_attributes(source, target, target_project_params)

      # Retain the project in the state for other dependent
      # copy services to use
      state.project = target

      call
    end

    def retain_attributes(source, target, target_project_params)
      # Ensure we keep the public value of the source project
      # which might get overridden by the SetAttributesService
      # unless the user provided a different value
      target.public = source.public unless target_project_params.key?(:public)
    end

    def cleanup_target_project_params(_source, _target, target_project_params)
      if (parent_id = target_project_params[:parent_id]) && (parent = Project.find_by(id: parent_id)) && !user.allowed_to?(
        :add_subprojects, parent
      )
        target_project_params.delete(:parent_id)
      end
    end

    def cleanup_target_project_attributes(_source, target, _target_project_params)
      if target.parent && !user.allowed_to?(:add_subprojects, target.parent)
        target.parent = nil
      end
    end

    def skipped_attributes
      %w[id created_at updated_at name identifier active templated lft rgt]
    end
  end
end
