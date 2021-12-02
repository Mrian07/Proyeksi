#-- encoding: UTF-8



module ProyeksiApp::AuthPlugins
  class Hooks < ProyeksiApp::Hook::ViewListener
    render_on :view_account_login_auth_provider, partial: 'hooks/login/providers'
    render_on :view_layouts_base_html_head, partial: 'hooks/login/providers_css'
  end
end
