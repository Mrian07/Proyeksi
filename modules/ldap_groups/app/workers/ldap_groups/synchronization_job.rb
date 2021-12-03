#-- encoding: UTF-8



module LdapGroups
  class SynchronizationJob < ::Cron::CronJob
    # Run every 30 minutes
    self.cron_expression = '*/30 * * * *'

    def perform
      return unless EnterpriseToken.allows_to?(:ldap_groups)
      return if skipped?

      ::LdapGroups::SynchronizationService.synchronize!
    end

    def skipped?
      ProyeksiApp::Configuration.ldap_groups_disable_sync_job?
    end
  end
end
