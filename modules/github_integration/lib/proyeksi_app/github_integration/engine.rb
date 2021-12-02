

require 'proyeksi_app/plugins'

require_relative './patches/api/work_package_representer'
require_relative './notification_handler'
require_relative './hook_handler'
require_relative './services'

module ProyeksiApp::GithubIntegration
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_github_integration

    include ProyeksiApp::Plugins::ActsAsOpEngine

    register 'proyeksiapp-github_integration',
             author_url: 'https://www.proyeksiapp.org/',
             bundled: true

    initializer 'github.register_hook' do
      ::ProyeksiApp::Webhooks.register_hook 'github' do |hook, environment, params, user|
        HookHandler.new.process(hook, environment, params, user)
      end
    end

    initializer 'github.subscribe_to_notifications' do
      ::ProyeksiApp::Notifications.subscribe('github.check_run',
                                             &NotificationHandler.method(:check_run))
      ::ProyeksiApp::Notifications.subscribe('github.issue_comment',
                                             &NotificationHandler.method(:issue_comment))
      ::ProyeksiApp::Notifications.subscribe('github.pull_request',
                                             &NotificationHandler.method(:pull_request))
    end

    initializer 'github.permissions' do
      ProyeksiApp::AccessControl.map do |ac_map|
        ac_map.project_module(:github, dependencies: :work_package_tracking) do |pm_map|
          pm_map.permission(:show_github_content, {}, {})
        end
      end
    end

    extend_api_response(:v3, :work_packages, :work_package,
                        &::ProyeksiApp::GithubIntegration::Patches::API::WorkPackageRepresenter.extension)

    add_api_path :github_pull_requests_by_work_package do |id|
      "#{work_package(id)}/github_pull_requests"
    end

    add_api_path :github_user do |id|
      "github_users/#{id}"
    end

    add_api_path :github_check_run do |id|
      "github_check_run/#{id}"
    end

    add_api_endpoint 'API::V3::WorkPackages::WorkPackagesAPI', :id do
      mount ::API::V3::GithubPullRequests::GithubPullRequestsByWorkPackageAPI
    end

    config.to_prepare do
      # Register the cron job to clean up old github pull requests
      ::Cron::CronJob.register! ::Cron::ClearOldPullRequestsJob
    end
  end
end
