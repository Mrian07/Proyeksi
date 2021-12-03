#-- encoding: UTF-8



module ProyeksiApp
  module Static
    module Links
      class << self
        def help_link_overridden?
          ProyeksiApp::Configuration.force_help_link.present?
        end

        def help_link
          ProyeksiApp::Configuration.force_help_link.presence || static_links[:user_guides]
        end

        def [](name)
          links[name]
        end

        def links
          @links ||= static_links.merge(dynamic_links)
        end

        def has?(name)
          @links.key? name
        end

        private

        def dynamic_links
          dynamic = {
            help: {
              href: help_link,
              label: 'top_menu.help_and_support'
            }
          }

          if impressum_link = ProyeksiApp::Configuration.impressum_link
            dynamic[:impressum] = {
              href: impressum_link,
              label: :label_impressum
            }
          end

          dynamic
        end

        def static_links
          {
            upsale: {
              href: 'https://www.proyeksiapp.org/enterprise-edition',
              label: 'homescreen.links.upgrade_enterprise_edition'
            },
            upsale_benefits_features: {
              href: 'https://www.proyeksiapp.org/enterprise-edition/#premium-features',
              label: 'noscript_learn_more'
            },
            upsale_benefits_installation: {
              href: 'https://www.proyeksiapp.org/enterprise-edition/#installation',
              label: 'noscript_learn_more'
            },
            upsale_benefits_security: {
              href: 'https://www.proyeksiapp.org/enterprise-edition/#security-features',
              label: 'noscript_learn_more'
            },
            upsale_benefits_support: {
              href: 'https://www.proyeksiapp.org/enterprise-edition/#professional-support',
              label: 'noscript_learn_more'
            },
            upsale_get_quote: {
              href: 'https://www.proyeksiapp.org/upgrade-enterprise-edition/',
              label: 'admin.enterprise.get_quote'
            },
            user_guides: {
              href: 'https://docs.proyeksiapp.org/user-guide/',
              label: 'homescreen.links.user_guides'
            },
            upgrade_guides: {
              href: 'https://www.proyeksiapp.org/operations/upgrading/',
              label: :label_upgrade_guides
            },
            postgres_migration: {
              href: 'https://www.proyeksiapp.org/operations/migration-guides/migrating-packaged-proyeksiapp-database-postgresql/',
              label: :'homescreen.links.postgres_migration'
            },
            postgres_13_upgrade: {
              href: 'https://docs.proyeksiapp.org/installation-and-operations/misc/migration-to-postgresql13/'
            },
            configuration_guide: {
              href: 'https://www.proyeksiapp.org/operations/configuration/',
              label: 'links.configuration_guide'
            },
            contact: {
              href: 'https://www.proyeksiapp.org/contact-us/',
              label: 'links.get_in_touch'
            },
            glossary: {
              href: 'https://www.proyeksiapp.org/help/glossary/',
              label: 'homescreen.links.glossary'
            },
            shortcuts: {
              href: 'https://docs.proyeksiapp.org/user-guide/keyboard-shortcuts-access-keys/',
              label: 'homescreen.links.shortcuts'
            },
            forums: {
              href: 'https://community.proyeksiapp.com/projects/proyeksiapp/forums',
              label: 'homescreen.links.forums'
            },
            professional_support: {
              href: 'https://www.proyeksiapp.org/pricing/#support',
              label: :label_professional_support
            },
            website: {
              href: 'https://www.proyeksiapp.org',
              label: 'label_proyeksiapp_website'
            },
            newsletter: {
              href: 'https://www.proyeksiapp.org/newsletter',
              label: 'homescreen.links.newsletter'
            },
            blog: {
              href: 'https://www.proyeksiapp.org/blog',
              label: 'homescreen.links.blog'
            },
            release_notes: {
              href: 'https://docs.proyeksiapp.org/release-notes/',
              label: :label_release_notes
            },
            data_privacy: {
              href: 'https://www.proyeksiapp.org/data-privacy-and-security/',
              label: :label_privacy_policy
            },
            report_bug: {
              href: 'https://docs.proyeksiapp.org/development/report-a-bug/',
              label: :label_report_bug
            },
            roadmap: {
              href: 'https://community.proyeksiapp.org/projects/proyeksiapp/roadmap',
              label: :label_development_roadmap
            },
            crowdin: {
              href: 'https://crowdin.com/projects/opf',
              label: :label_add_edit_translations
            },
            api_docs: {
              href: 'https://docs.proyeksiapp.org/api',
              label: :label_api_documentation
            },
            text_formatting: {
              href: 'https://docs.proyeksiapp.org/user-guide/wiki/',
              label: :setting_text_formatting
            },
            oauth_authorization_code_flow: {
              href: 'https://oauth.net/2/grant-types/authorization-code/',
              label: 'oauth.flows.authorization_code'
            },
            client_credentials_code_flow: {
              href: 'https://oauth.net/2/grant-types/client-credentials/',
              label: 'oauth.flows.client_credentials'
            },
            ldap_encryption_documentation: {
              href: 'https://www.rubydoc.info/gems/net-ldap/Net/LDAP#constructor_details'
            },
            origin_mdn_documentation: {
              href: 'https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Origin'
            },
            security_badge_documentation: {
              href: 'https://docs.proyeksiapp.org/system-admin-guide/information/#security-badge'
            },
            display_settings_documentation: {
              href: 'https://docs.proyeksiapp.org/system-admin-guide/system-settings/display-settings/'
            },
            chargebee: {
              href: 'https://js.chargebee.com/v2/chargebee.js'
            },
            webinar_videos: {
              href: 'https://www.youtube.com/watch?v=un6zCm8_FT4'
            },
            get_started_videos: {
              href: 'https://www.youtube.com/playlist?list=PLGzJ4gG7hPb8WWOWmeXqlfMfhdXReu-RJ'
            },
            proyeksiapp_docs: {
              href: 'https://docs.proyeksiapp.org'
            },
            contact_us: {
              href: 'https://www.proyeksiapp.org/contact-us'
            }
          }
        end
      end
    end
  end
end
