module API
  module V3
    module Backups
      class BackupsAPI < ::API::ProyeksiAppAPI
        resources :backups do
          before do
            raise API::Errors::NotFound unless ProyeksiApp::Configuration.backup_enabled?
          end

          after_validation do
            authorize Backup.permission, global: true
          end

          params do
            requires :backupToken, type: String

            optional(
              :attachments,
              type: Boolean,
              default: true,
              desc: 'Whether or not to include attachments (default: true)'
            )
          end
          post do
            service = ::Backups::CreateService.new(
              user: current_user,
              backup_token: params[:backupToken],
              include_attachments: params[:attachments]
            )
            call = service.call

            if call.failure?
              errors = call.errors.errors

              if err = errors.find { |e| e.type == :invalid_token || e.type == :token_cooldown }
                fail ::API::Errors::Unauthorized, message: err.full_message
              elsif err = errors.find { |e| e.type == :backup_pending }
                fail ::API::Errors::Conflict, message: err.full_message
              elsif err = errors.find { |e| e.type == :limit_reached }
                fail ::API::Errors::TooManyRequests, message: err.full_message
              end

              fail ::API::Errors::ErrorBase.create_and_merge_errors(call.errors)
            end

            status 202

            BackupRepresenter.new call.result, current_user: current_user
          end
        end
      end
    end
  end
end
