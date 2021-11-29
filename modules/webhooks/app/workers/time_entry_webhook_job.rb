require 'rest-client'

#-- encoding: UTF-8


class TimeEntryWebhookJob < RepresentedWebhookJob
  def payload_key
    :time_entry
  end

  def payload_representer
    User.system.run_given do |user|
      ::API::V3::TimeEntries::TimeEntryRepresenter
        .create(resource, current_user: user, embed_links: true)
    end
  end
end
