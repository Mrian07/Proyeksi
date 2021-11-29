

module OpenProject::Avatars
  class Engine < ::Rails::Engine
    engine_name :openproject_avatars

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-avatars',
             author_url: 'https://www.openproject.org',
             settings: {
               default: {
                 enable_gravatars: true,
                 enable_local_avatars: true
               },
               partial: 'settings/openproject_avatars',
               menu_item: :user_avatars
             },
             name: :label_avatar_plural,
             bundled: true do
      add_menu_item :my_menu, :avatar,
                    { controller: '/avatars/my_avatar', action: 'show' },
                    caption: ->(*) { I18n.t('avatars.label_avatar') },
                    if: ->(*) { ::OpenProject::Avatars::AvatarManager::avatars_enabled? },
                    icon: 'icon2 icon-image1'
    end

    config.to_prepare do
      require_dependency 'project'
    end

    add_api_endpoint 'API::V3::Users::UsersAPI', :id do
      mount ::API::V3::Users::UserAvatarAPI
    end

    add_tab_entry :user,
                  name: 'avatar',
                  partial: 'avatars/users/avatar_tab',
                  path: ->(params) { edit_user_path(params[:user], tab: :avatar) },
                  label: :label_avatar,
                  only_if: ->(*) { User.current.admin? && ::OpenProject::Avatars::AvatarManager.avatars_enabled? }

    initializer 'patch avatar helper' do
      # This is required to be an initializer,
      # since the helpers are included as soon as the ApplicationController
      # gets autoloaded, which is BEFORE config.to_prepare.
      Rails.autoloaders.main.ignore(config.root.join('lib/open_project/avatars/patches/avatar_helper_patch.rb'))

      require_relative './patches/avatar_helper_patch'
    end

    patches %i[User]
  end
end
