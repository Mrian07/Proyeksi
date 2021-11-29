#-- encoding: UTF-8



module HomescreenHelper
  ##
  # Homescreen name
  def organization_name
    Setting.app_title || Setting.software_name
  end

  ##
  # Homescreen organization icon
  def organization_icon
    op_icon('icon-context icon-enterprise')
  end

  ##
  # Render a static link defined in OpenProject::Static::Links
  def static_link_to(key)
    link = OpenProject::Static::Links.links[key]
    label = I18n.t(link[:label])

    link_to label,
            link[:href],
            title: label,
            target: '_blank'
  end

  ##
  # Determine whether we should render the links on homescreen?
  def show_homescreen_links?
    EnterpriseToken.show_banners? || OpenProject::Configuration.show_community_links?
  end

  ##
  # Determine whether we should render the onboarding modal
  def show_onboarding_modal?
    OpenProject::Configuration.onboarding_enabled? && params[:first_time_user]
  end
end
