#-- encoding: UTF-8



module BackupHelper
  ##
  # The idea here is to only allow users, who can confirm their password, to backup
  # ProyeksiApp without delay. Users who can't (since they use Google etc.) have to wait
  # just to make sure no one else accessed the computer to trigger a backup.
  #
  #   A better long-term solution might be to introduce a PIN for sensitive operations
  #   in general. Think the PIN for Windows users or trading passwords in online trade platforms.
  #
  # Also we make sure that in case there is a password that it wasn't just set by a would-be attacker.
  #
  # If ProyeksiApp has just been installed we don't check any of this since there's likely nothing
  # sensitive to backup yet and it would prevent a new admin from trying this feature.
  def allow_instant_backup_for_user?(user, date: instant_backup_threshold_date)
    return true if just_installed_proyeksiapp? after: date

    # user doesn't use OpenIDConnect (so can be asked to confirm their password)
    !user.uses_external_authentication? &&
      # user cannot change password in OP (LDAP) or hasn't changed it recently
      (user.passwords.empty? || user.passwords.first.updated_at < date)
  end

  def instant_backup_threshold_date
    DateTime.now - ProyeksiApp::Configuration.backup_initial_waiting_period
  end

  def just_installed_proyeksiapp?(after: instant_backup_threshold_date)
    created_at = User.order(created_at: :asc).limit(1).pick(:created_at)

    created_at && created_at >= after
  end

  def create_backup_token(user: current_user)
    token = Token::Backup.create! user: user

    # activate token right away as user had to confirm password
    date = instant_backup_threshold_date
    if allow_instant_backup_for_user? user, date: date
      token.update_column :created_at, date
    end

    token
  end

  def notify_user_and_admins(user, backup_token:)
    waiting_period = backup_token.waiting? && ProyeksiApp::Configuration.backup_initial_waiting_period
    users = ([user] + User.admin.active).uniq

    users.each do |recipient|
      UserMailer.backup_token_reset(recipient, user: user, waiting_period: waiting_period).deliver_later
    end
  end
end
