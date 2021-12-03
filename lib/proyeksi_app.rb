#-- encoding: UTF-8



require 'redmine/menu_manager'
require 'redmine/search'
require 'proyeksi_app/custom_field_format'
require 'proyeksi_app/logging'
require 'proyeksi_app/patches'
require 'proyeksi_app/mime_type'
require 'proyeksi_app/custom_styles/design'
require 'proyeksi_app/hook'
require 'proyeksi_app/hooks'
require 'redmine/plugin'

require 'csv'

module ProyeksiApp
  ##
  # Shortcut to the ProyeksiApp log delegator, which extends
  # default Rails error handling with other error handlers such as sentry.
  def self.logger
    ::ProyeksiApp::Logging::LogDelegator
  end
end
