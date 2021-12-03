#-- encoding: UTF-8

module AdminHelper
  def project_status_options_for_select(selected)
    options_for_select([[I18n.t(:label_all), ''],
                        [I18n.t(:status_active), 1]], selected)
  end
end
