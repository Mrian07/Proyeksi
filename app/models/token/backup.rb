#-- encoding: UTF-8

module Token
  class Backup < HashedToken
    def ready?
      return false if created_at.nil?

      created_at.since(ProyeksiApp::Configuration.backup_initial_waiting_period).past?
    end

    def waiting?
      !ready?
    end
  end
end
