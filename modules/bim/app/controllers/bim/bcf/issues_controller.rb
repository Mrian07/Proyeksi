#-- encoding: UTF-8



module Bim
  module Bcf
    class IssuesController < BaseController
      include PaginationHelper

      before_action :find_project_by_project_id
      before_action :authorize
      before_action :import_canceled?

      before_action :check_file_param, only: %i[prepare_import]
      before_action :get_persisted_file, only: %i[perform_import configure_import]
      before_action :persist_file, only: %i[prepare_import]

      before_action :build_importer, only: %i[prepare_import configure_import perform_import]
      before_action :check_bcf_version, only: %i[prepare_import]

      menu_item :ifc_models

      def upload; end

      def index
        redirect_to action: :upload
      end

      def prepare_import
        render_next
      rescue StandardError => e
        flash[:error] = I18n.t('bcf.bcf_xml.import_failed', error: e.message)
        redirect_to action: :upload
      end

      def configure_import
        render_next
      rescue StandardError => e
        flash[:error] = I18n.t('bcf.bcf_xml.import_failed', error: e.message)
        redirect_to action: :upload
      end

      def perform_import
        import_file
      rescue StandardError => e
        flash[:error] = I18n.t('bcf.bcf_xml.import_failed', error: e.message)
        redirect_to action: :upload
      ensure
        @bcf_attachment&.destroy
      end

      def redirect_to_bcf_issues_listset
        redirect_to defaults_bcf_project_ifc_models_path(@project)
      end

      private

      def import_file
        set_import_options

        results = @importer.import!(@import_options).flatten
        @issues = { successful: [], failed: [] }
        results.each do |issue|
          if issue.errors.present?
            @issues[:failed] << issue
          else
            @issues[:successful] << issue
          end
        end
      end

      def import_canceled?
        if %i[unknown_types_action
              unknown_statuses_action
              invalid_people_action
              unknown_mails_action
              non_members_action].map { |key| params.dig(:import_options, key) }.include? 'cancel'
          flash[:notice] = I18n.t('bcf.bcf_xml.import_canceled')
          redirect_to_bcf_issues_list
        end
      end

      def set_import_options
        @import_options = {
          unknown_types_action: params.dig(:import_options, :unknown_types_action).presence || "use_default",
          unknown_statuses_action: params.dig(:import_options, :unknown_statuses_action).presence || "use_default",
          unknown_priorities_action: params.dig(:import_options, :unknown_priorities_action).presence || "use_default",
          invalid_people_action: params.dig(:import_options, :invalid_people_action).presence || "anonymize",
          unknown_mails_action: params.dig(:import_options, :unknown_mails_action).presence || 'invite',
          non_members_action: params.dig(:import_options, :non_members_action).presence || 'chose',
          unknown_types_chose_ids: params.dig(:import_options, :unknown_types_chose_ids) || [],
          unknown_statuses_chose_ids: params.dig(:import_options, :unknown_statuses_chose_ids) || [],
          unknown_priorities_chose_ids: params.dig(:import_options, :unknown_priorities_chose_ids) || [],
          unknown_mails_invite_role_ids: params.dig(:import_options, :unknown_mails_invite_role_ids) || [],
          non_members_chose_role_ids: params.dig(:import_options, :non_members_chose_role_ids) || []
        }
      end

      def render_next
        if render_config_unknown_types?
          render_config_unknown_types
        elsif render_config_unknown_statuses?
          render_config_unknown_statuses
        elsif render_config_unknown_priorities?
          render_config_unknown_priorities
        elsif render_config_invalid_people?
          render_config_invalid_people
        elsif render_config_unknown_mails?
          render_config_unknown_mails
        elsif render_config_non_members?
          render_config_non_members
        else
          import_file
          render :perform_import
        end
      end

      def render_config_invalid_people
        render 'bim/bcf/issues/configure_invalid_people'
      end

      def render_config_invalid_people?
        @importer.aggregations.invalid_people.present? && !params.dig(:import_options, :invalid_people_action).present?
      end

      def render_config_unknown_types
        render 'bim/bcf/issues/configure_unknown_types'
      end

      def render_config_unknown_types?
        @importer.aggregations.unknown_types.present? && !params.dig(:import_options, :unknown_types_action).present?
      end

      def render_config_unknown_statuses
        render 'bim/bcf/issues/configure_unknown_statuses'
      end

      def render_config_unknown_statuses?
        @importer.aggregations.unknown_statuses.present? && !params.dig(:import_options, :unknown_statuses_action).present?
      end

      def render_config_unknown_priorities?
        @importer.aggregations.unknown_priorities.present? && !params.dig(:import_options, :unknown_priorities_action).present?
      end

      def render_config_unknown_priorities
        render 'bim/bcf/issues/configure_unknown_priorities'
      end

      def render_config_unknown_mails
        @roles = Role.givable
        render 'bim/bcf/issues/configure_unknown_mails'
      end

      def render_config_unknown_mails?
        @importer.aggregations.unknown_mails.present? && !params.dig(:import_options, :unknown_mails_action).present?
      end

      def render_config_non_members
        @roles = Role.givable
        render 'bim/bcf/issues/configure_non_members'
      end

      def render_config_non_members?
        @importer.aggregations.non_members.present? && !params.dig(:import_options, :non_members_action).present?
      end

      def build_importer
        @importer = ::ProyeksiApp::Bim::BcfXml::Importer.new(@bcf_xml_file, @project, current_user: current_user)
      end

      def get_persisted_file
        @bcf_attachment = Attachment.find_by!(id: session[:bcf_file_id], author: current_user)
        @bcf_xml_file = File.new @bcf_attachment.local_path
      rescue ActiveRecord::RecordNotFound
        flash[:error] = I18n.t('bcf.bcf_xml.import.bcf_file_not_found')
        redirect_to action: :upload
      end

      def persist_file
        @bcf_attachment = create_attachment
        @bcf_xml_file = File.new(@bcf_attachment.local_path)
        session[:bcf_file_id] = @bcf_attachment.id
      rescue StandardError => e
        flash[:error] = "Failed to persist BCF file: #{e.message}"
        redirect_to action: :upload
      end

      def create_attachment
        filename = params[:bcf_file].original_filename
        call = Attachments::CreateService
          .bypass_whitelist(user: current_user, whitelist: %w[application/zip])
          .call(file: params[:bcf_file],
                filename: filename,
                description: filename)

        call.on_failure { raise e.message }

        call.result
      end

      def check_file_param
        path = params[:bcf_file]&.path
        unless path && File.readable?(path)
          flash[:error] = I18n.t('bcf.bcf_xml.import_failed', error: 'File missing or not readable')
          redirect_to action: :upload
        end
      end

      def check_bcf_version
        unless @importer.bcf_version_valid?
          flash[:error] =
            I18n.t('bcf.bcf_xml.import_failed_unsupported_bcf_version',
                   minimal_version: ProyeksiApp::Bim::BcfXml::Importer::MINIMUM_BCF_VERSION)
          redirect_to action: :upload
        end
      end
    end
  end
end
