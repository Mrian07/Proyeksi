#-- encoding: UTF-8



module Backups
  class CreateService < ::BaseServices::Create
    def initialize(user:, backup_token:, include_attachments: true, contract_class: ::Backups::CreateContract)
      super user: user, contract_class: contract_class, contract_options: { backup_token: backup_token }

      @include_attachments = include_attachments
    end

    def include_attachments?
      @include_attachments
    end

    def after_perform(call)
      if call.success?
        BackupJob.perform_later(
          backup: call.result,
          user: user,
          include_attachments: include_attachments?
        )
      end

      call
    end
  end
end
