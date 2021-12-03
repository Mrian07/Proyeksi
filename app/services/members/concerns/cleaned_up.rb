module Members::Concerns::CleanedUp
  extend ActiveSupport::Concern

  included do
    around_call :cleanup_members

    protected

    def cleanup_members
      service_call = yield

      return unless service_call.success?

      member = service_call.result

      Members::CleanupService
        .new(member.principal, member.project_id)
        .call
    end
  end
end
