#-- encoding: UTF-8



class AttachmentWebhookJob < RepresentedWebhookJob
  def payload_key
    :attachment
  end

  def accepted_in_project?
    project = resource.container.try(:project)
    return true if project.nil?

    webhook.enabled_for_project?(project.id)
  end

  def payload_representer
    User.system.run_given do |user|
      ::API::V3::Attachments::AttachmentRepresenter
        .create(resource, current_user: user, embed_links: true)
    end
  end
end
