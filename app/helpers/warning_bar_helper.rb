#-- encoding: UTF-8



module WarningBarHelper
  def render_pending_migrations_warning?
    current_user.admin? &&
      OpenProject::Configuration.show_pending_migrations_warning? &&
      OpenProject::Database.migrations_pending?
  end

  def render_host_and_protocol_mismatch?
    current_user.admin? &&
      OpenProject::Configuration.show_setting_mismatch_warning? &&
      (setting_protocol_mismatched? || setting_hostname_mismatched?)
  end

  def setting_protocol_mismatched?
    (request.ssl? && Setting.protocol == 'http') || (!request.ssl? && Setting.protocol == 'https')
  end

  def setting_hostname_mismatched?
    Setting.host_name.gsub(/:\d+$/, '') != request.host
  end

  ##
  # By default, never show a warning bar in the
  # test mode due to overshadowing other elements.
  def show_warning_bar?
    OpenProject::Configuration.show_warning_bars?
  end
end
