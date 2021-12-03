#-- encoding: UTF-8

class VersionsController < ApplicationController
  menu_item :roadmap, only: %i(index show)
  menu_item :settings_versions

  model_object Version
  before_action :find_model_object, except: %i[index new create close_completed]
  before_action :find_project_from_association, except: %i[index new create close_completed]
  before_action :find_project, only: %i[index new create close_completed]
  before_action :authorize

  def index
    @types = @project.types.order(Arel.sql('position'))
    retrieve_selected_type_ids(@types, @types.select(&:is_in_roadmap?))
    @with_subprojects = params[:with_subprojects].nil? ? Setting.display_subprojects_work_packages? : (params[:with_subprojects].to_i == 1)
    project_ids = @with_subprojects ? @project.self_and_descendants.map(&:id) : [@project.id]

    @versions = find_versions(@with_subprojects, params[:completed])

    @wps_by_version = {}
    unless @selected_type_ids.empty?
      @versions.each do |version|
        @wps_by_version[version] = work_packages_of_version(version, project_ids, @selected_type_ids)
      end
    end
    @versions.reject! { |version| !project_ids.include?(version.project_id) && @wps_by_version[version].blank? }
  end

  def show
    @issues = @version
                .work_packages
                .visible
                .includes(:status, :type, :priority)
                .order("#{::Type.table_name}.position, #{WorkPackage.table_name}.id")
  end

  def new
    @version = @project.versions.build
  end

  def create
    attributes = permitted_params
                   .version
                   .merge(project_id: @project.id)

    call = Versions::CreateService
             .new(user: current_user)
             .call(attributes)

    render_cu(call, :notice_successful_create, 'new')
  end

  def edit; end

  def update
    attributes = permitted_params
                   .version

    call = Versions::UpdateService
             .new(user: current_user,
                  model: @version)
             .call(attributes)

    render_cu(call, :notice_successful_update, 'edit')
  end

  def close_completed
    if request.put?
      @project.close_completed_versions
    end
    redirect_to project_settings_versions_path(@project)
  end

  def destroy
    call = Versions::DeleteService
             .new(user: current_user,
                  model: @version)
             .call

    unless call.success?
      flash[:error] = call.errors.full_messages
    end

    redirect_to project_settings_versions_path(@project)
  end

  private

  def redirect_back_or_version_settings
    redirect_back_or_default(project_settings_versions_path(@project))
  end

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def retrieve_selected_type_ids(selectable_types, default_types = nil)
    @selected_type_ids = selected_type_ids selectable_types, default_types
  end

  def selected_type_ids(selectable_types, default_types = nil)
    if (ids = params[:type_ids])
      ids.is_a?(Array) ? ids.map(&:to_s) : ids.split('/')
    else
      (default_types || selectable_types).map { |t| t.id.to_s }
    end
  end

  def render_cu(call, success_message, failure_action)
    @version = call.result

    if call.success?
      flash[:notice] = t(success_message)
      redirect_back_or_version_settings
    else
      @errors = call.errors

      render action: failure_action
    end
  end

  def find_versions(subprojects, completed)
    versions = @project.shared_versions

    if subprojects
      versions = versions.or(@project.rolled_up_versions)
    end

    versions = versions.visible.order_by_semver_name.except(:distinct).uniq
    versions.reject! { |version| version.closed? || version.completed? } unless completed
    versions
  end

  def work_packages_of_version(version, project_ids, selected_type_ids)
    version
      .work_packages
      .visible
      .includes(:project, :status, :type, :priority)
      .where(type_id: selected_type_ids, project_id: project_ids)
      .order("#{Project.table_name}.lft, #{::Type.table_name}.position, #{WorkPackage.table_name}.id")
  end
end
