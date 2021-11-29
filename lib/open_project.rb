#-- encoding: UTF-8



require 'redmine/menu_manager'
require 'redmine/search'
require 'open_project/custom_field_format'
require 'open_project/logging'
require 'open_project/patches'
require 'open_project/mime_type'
require 'open_project/custom_styles/design'
require 'open_project/hook'
require 'open_project/hooks'
require 'redmine/plugin'

require 'csv'

module OpenProject
  ##
  # Shortcut to the OpenProject log delegator, which extends
  # default Rails error handling with other error handlers such as sentry.
  def self.logger
    ::OpenProject::Logging::LogDelegator
  end
end
