module RecaptchaHelper
  def recaptcha_available_options
    [
      [I18n.t('recaptcha.settings.type_disabled'), ::ProyeksiApp::Recaptcha::TYPE_DISABLED],
      [I18n.t('recaptcha.settings.type_v2'), ::ProyeksiApp::Recaptcha::TYPE_V2],
      [I18n.t('recaptcha.settings.type_v3'), ::ProyeksiApp::Recaptcha::TYPE_V3]
    ]
  end

  def recaptcha_settings
    Setting.plugin_proyeksiapp_recaptcha
  end
end
