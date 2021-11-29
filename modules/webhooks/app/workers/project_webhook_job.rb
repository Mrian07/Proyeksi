require 'rest-client'

#-- encoding: UTF-8


class ProjectWebhookJob < RepresentedWebhookJob
  def payload_key
    :project
  end

  def accepted_in_project?
    if event_name == 'project:created'
      true
    else
      webhook.enabled_for_project?(resource.id)
    end
  end

  def payload_representer
    User.system.run_given do |user|
      ::API::V3::Projects::ProjectRepresenter
        .create(resource, current_user: user, embed_links: true)
    end
  end
end
