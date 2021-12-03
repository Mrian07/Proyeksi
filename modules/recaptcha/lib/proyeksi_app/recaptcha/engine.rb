require 'proyeksi_app/plugins'
require 'recaptcha'

module ProyeksiApp::Recaptcha
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_recaptcha

    include ProyeksiApp::Plugins::ActsAsOpEngine

    register 'proyeksiapp-recaptcha',
             author_url: 'https://www.proyeksiapp.org',
             settings: {
               default: {
                 recaptcha_type: ::ProyeksiApp::Recaptcha::TYPE_DISABLED
               }
             },
             bundled: true do
      menu :admin_menu,
           :plugin_recaptcha,
           { controller: '/recaptcha/admin', action: :show },
           parent: :authentication,
           caption: ->(*) { I18n.t('recaptcha.label_recaptcha') }
    end

    config.after_initialize do
      SecureHeaders::Configuration.named_append(:recaptcha) do |request|
        if ProyeksiApp::Recaptcha.use_hcaptcha?
          value = %w(https://*.hcaptcha.com)
          keys = %i(frame_src script_src style_src connect_src)

          keys.index_with value
        else
          {
            frame_src: %w(https://www.google.com/recaptcha/)
          }
        end
      end

      ProyeksiApp::Authentication::Stage.register(
        :recaptcha,
        nil,
        run_after_activation: true,
        active: -> {
          type = Setting.plugin_proyeksiapp_recaptcha[:recaptcha_type]

          type.present? && type.to_s != ::ProyeksiApp::Recaptcha::TYPE_DISABLED
        }
      ) do
        recaptcha_request_path
      end
    end
  end
end
