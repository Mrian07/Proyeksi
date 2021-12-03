module ProyeksiApp
  module Recaptcha
    TYPE_DISABLED ||= 'disabled'
    TYPE_V2 ||= 'v2'
    TYPE_V3 ||= 'v3'

    require "proyeksi_app/recaptcha/engine"
    require "proyeksi_app/recaptcha/configuration"

    extend Configuration
  end
end
