#-- encoding: UTF-8



class WorkPackagesController < ApplicationController
  include QueriesHelper
  include PaginationHelper
  include Layout

  accept_key_auth :index, :show

  before_action :authorize_on_work_package,
                :project, only: :show
  before_action :find_optional_project,
                :protect_from_unauthorized_export, only: :index

  before_action :load_and_validate_query, only: :index, unless: -> { request.format.html? }
  before_action :load_work_packages, only: :index, if: -> { request.format.atom? }

  def show
    respond_to do |format|
      format.html do
        render :show,
               locals: { work_package: work_package, menu_name: project_or_wp_query_menu },
               layout: 'angular/angular'
      end

      format.any(*supported_single_formats) do
        export_single(request.format.symbol)
      end

      format.atom do
        atom_journals
      end

      format.all do
        head :not_acceptable
      end
    end
  end

  def index
    respond_to do |format|
      format.html do
        render :index,
               locals: { query: @query, project: @project, menu_name: project_or_wp_query_menu },
               layout: 'angular/angular'
      end

      format.any(*supported_list_formats) do
        export_list(request.format.symbol)
      end

      format.atom do
        atom_list
      end
    end
  end

  protected

  def export_list(mime_type)
    job_id = WorkPackages::Exports::ScheduleService
      .new(user: current_user)
      .call(query: @query, mime_type: mime_type, params: params)
      .result

    if request.headers['Accept']&.include?('application/json')
      render json: { job_id: job_id }
    else
      redirect_to job_status_path(job_id)
    end
  end

  def export_single(mime_type)
    exporter = Exports::Register
      .single_exporter(WorkPackage, mime_type)
      .new(work_package, params)

    export = exporter.export!
    send_data(export.content, type: export.mime_type, filename: export.title)
  rescue ::Exports::ExportError => e
    flash[:error] = e.message
    redirect_back(fallback_location: work_package_path(work_package))
  end

  def atom_journals
    render template: 'journals/index',
           layout: false,
           content_type: 'application/atom+xml',
           locals: { title: "#{Setting.app_title} - #{work_package}",
                     journals: journals }
  end

  def atom_list
    render_feed(@work_packages,
                title: "#{@project || Setting.app_title}: #{I18n.t(:label_work_package_plural)}")
  end

  private

  def authorize_on_work_package
    deny_access(not_found: true) unless work_package
  end

  def protect_from_unauthorized_export
    if (supported_list_formats + %w[atom]).include?(params[:format]) &&
       !User.current.allowed_to?(:export_work_packages, @project, global: @project.nil?)

      deny_access
      false
    end
  end

  def supported_list_formats
    ::Exports::Register.list_formats(WorkPackage).map(&:to_s)
  end

  def supported_single_formats
    ::Exports::Register.single_formats(WorkPackage).map(&:to_s)
  end

  def load_and_validate_query
    @query ||= retrieve_query

    unless @query.valid?
      # Ensure outputting an html response
      request.format = 'html'
      render_400(message: @query.errors.full_messages.join(". "))
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def per_page_param
    case params[:format]
    when 'atom'
      Setting.feeds_limit.to_i
    else
      super
    end
  end

  def project
    @project ||= work_package ? work_package.project : nil
  end

  def work_package
    @work_package ||= WorkPackage.visible(current_user).find_by(id: params[:id])
  end

  def journals
    @journals ||= begin
      order =
        if current_user.wants_comments_in_reverse_order?
          Journal.arel_table['created_at'].desc
        else
          Journal.arel_table['created_at'].asc
        end

      work_package
        .journals
        .changing
        .includes(:user)
        .order(order).to_a
    end
  end

  def index_redirect_path
    if @project
      project_work_packages_path(@project)
    else
      work_packages_path
    end
  end

  def load_work_packages
    @results = @query.results
    @work_packages =
      if @query.valid?
        @results
          .work_packages
          .page(page_param)
          .per_page(per_page_param)
      else
        []
      end
  end

  def login_back_url_params
    params.permit(:query_id, :state, :query_props)
  end
end