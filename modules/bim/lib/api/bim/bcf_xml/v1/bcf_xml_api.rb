

module API
  module Bim
    module BcfXml
      module V1
        class BcfXmlAPI < ::API::ProyeksiAppAPI
          prefix :bcf_xml_api

          resources :projects do
            route_param :id do
              namespace 'bcf_xml' do
                helpers do
                  # Global helper to set allowed content_types
                  # This may be overridden when multipart is allowed (file uploads)
                  def allowed_content_types
                    if post_request?
                      %w(multipart/form-data)
                    else
                      super
                    end
                  end

                  def post_request?
                    request.env['REQUEST_METHOD'] == 'POST'
                  end

                  def import_options
                    params[:import_options].presence || {}
                  end

                  def find_project
                    Project.find(params[:id])
                  end
                end

                get do
                  project = find_project

                  authorize(:view_linked_issues, context: project) do
                    raise API::Errors::NotFound.new
                  end

                  query = Query.new_default(name: '_', project: project)
                  updated_query = ::API::V3::UpdateQueryFromV3ParamsService.new(query, User.current).call(params)

                  exporter = ::ProyeksiApp::Bim::BcfXml::Exporter.new(updated_query.result)
                  header['Content-Disposition'] = "attachment; filename=\"#{exporter.bcf_filename}\""
                  env['api.format'] = :binary
                  exporter.export!.content.read
                end

                post do
                  project = find_project

                  authorize(:manage_bcf, context: project) do
                    raise API::Errors::NotFound.new
                  end

                  begin
                    file = params[:bcf_xml_file][:tempfile]
                    importer = ::ProyeksiApp::Bim::BcfXml::Importer.new(file,
                                                                        project,
                                                                        current_user: User.current)

                    unless importer.bcf_version_valid?
                      error_message = I18n.t('bcf.bcf_xml.import_failed_unsupported_bcf_version',
                                             minimal_version: ProyeksiApp::Bim::BcfXml::Importer::MINIMUM_BCF_VERSION)

                      raise API::Errors::UnsupportedMediaType.new(error_message)
                    end

                    importer.import!(import_options)
                  rescue API::Errors::UnsupportedMediaType => e
                    raise e
                  rescue StandardError => e
                    raise API::Errors::InternalError.new(e.message)
                  ensure
                    file.delete
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
