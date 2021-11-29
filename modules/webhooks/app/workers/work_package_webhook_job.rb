require 'rest-client'

#-- encoding: UTF-8


class WorkPackageWebhookJob < RepresentedWebhookJob
  def payload_key
    :work_package
  end

  def payload_representer
    User.system.run_given do |user|
      ::API::V3::WorkPackages::WorkPackageRepresenter
        .create(resource, current_user: user, embed_links: true)
    end
  end
end
