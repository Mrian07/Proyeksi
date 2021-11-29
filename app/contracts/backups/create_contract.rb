

module Backups
  class CreateContract < ::ModelContract
    include SingleTableInheritanceModelContract

    validate :user_allowed_to_create_backup
    validate :backup_token
    validate :backup_limit
    validate :no_pending_backups

    private

    def backup_token
      token = Token::Backup.find_by_plaintext_value options[:backup_token].to_s

      if token.blank? || token.user_id != user.id
        errors.add :base, :invalid_token, message: I18n.t("backup.error.invalid_token")
      else
        check_waiting_period token
      end
    end

    def check_waiting_period(token)
      if token.waiting?
        valid_at = token.created_at + OpenProject::Configuration.backup_initial_waiting_period
        hours = ((valid_at - Time.zone.now) / 60.0 / 60.0).round

        errors.add :base, :token_cooldown, message: I18n.t("backup.error.token_cooldown", hours: hours)
      end
    end

    def backup_limit
      limit = OpenProject::Configuration.backup_daily_limit
      if Backup.where("created_at >= ?", Time.zone.today).count > limit
        errors.add :base, :limit_reached, message: I18n.t("backup.error.limit_reached", limit: limit)
      end
    end

    def no_pending_backups
      current_backup = Backup.last
      if pending_statuses.include? current_backup&.job_status&.status
        errors.add :base, :backup_pending, message: I18n.t("backup.error.backup_pending")
      end
    end

    def user_allowed_to_create_backup
      errors.add :base, :error_unauthorized unless user_allowed_to_create_backup?
    end

    def user_allowed_to_create_backup?
      user.allowed_to_globally? Backup.permission
    end

    def pending_statuses
      ::JobStatus::Status.statuses.slice(:in_queue, :in_process).values
    end
  end
end
