

class ProyeksiApp::Backlogs::Hooks::UserSettingsHook < ProyeksiApp::Hook::ViewListener
  # Updates the backlogs settings before saving the user
  #
  # Context:
  # * params => Request parameters
  # * permitted_params => whitelisted params
  # * user => user being altered
  def service_update_user_before_save(context = {})
    params = context[:params]
    user = context[:user]

    backlogs_params = params.delete(:backlogs)
    return unless backlogs_params

    versions_default_fold_state = backlogs_params[:versions_default_fold_state] || 'open'
    user.backlogs_preference(:versions_default_fold_state, versions_default_fold_state)

    color = backlogs_params[:task_color] || ''
    if color == '' || color.match(/^#[A-Fa-f0-9]{6}$/)
      user.backlogs_preference(:task_color, color)
    end
  end
end
