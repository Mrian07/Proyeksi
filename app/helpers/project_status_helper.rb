#-- encoding: UTF-8



module ProjectStatusHelper
  def project_status_css_class(status)
    code = project_status_ensure_default_code(status)
    '-' + code.tr('_', '-')
  end

  def project_status_name(status)
    code = project_status_ensure_default_code(status)
    project_status_name_for_code(code)
  end

  def project_status_name_for_code(code)
    code ||= 'not_set'
    I18n.t('js.grid.widgets.project_status.' + code)
  end

  def project_status_ensure_default_code(status)
    status.try(:code) || 'not_set'
  end
end
