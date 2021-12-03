

# This patch adds our job status extension to background jobs carried out when mailing with
# perform_later.

module ProyeksiApp
  module Patches
    module DeliveryJob
      # include ::JobStatus::ApplicationJobWithStatus
    end
  end
end

ActionMailer::MailDeliveryJob.include ::JobStatus::ApplicationJobWithStatus
