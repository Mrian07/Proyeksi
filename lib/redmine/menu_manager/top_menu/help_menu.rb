

module Redmine::MenuManager::TopMenu::HelpMenu
  def render_help_top_menu_node(item = help_menu_item)
    cache_key = ['help_top_menu_node',
                 ProyeksiApp::Static::Links.links,
                 I18n.locale,
                 ProyeksiApp::Static::Links.help_link]

    ProyeksiApp::Cache.fetch(cache_key) do
      if ProyeksiApp::Static::Links.help_link_overridden?
        content_tag('li',
                    render_single_menu_node(item, nil, 'op-app-menu'),
                    class: 'op-app-menu--item op-app-help op-app-help_overridden')
      else
        render_help_dropdown
      end
    end
  end

  def render_help_dropdown
    link_to_help_pop_up = link_to '#',
                                  title: I18n.t(:label_help),
                                  class: 'op-app-menu--item-action',
                                  aria: { haspopup: 'true' } do
      op_icon('icon-help op-app-help--icon')
    end

    render_menu_dropdown(
      link_to_help_pop_up,
      menu_item_class: 'op-app-help hidden-for-mobile',
      drop_down_class: 'op-menu'
    ) do
      result = ''.html_safe
      render_onboarding result
      render_help_and_support result
      render_additional_resources result

      result
    end
  end

  private

  def render_onboarding(result)
    result << content_tag(:li, class: 'op-menu--item') do
      content_tag(:span, I18n.t('top_menu.getting_started'),
                  class: 'op-menu--headline',
                  title: I18n.t('top_menu.getting_started'))
    end
    result << render_onboarding_menu_item
    result << content_tag(:hr, '', class: 'op-menu--separator')
  end

  def render_onboarding_menu_item
    controller.render_to_string(partial: 'onboarding/menu_item')
  end

  def render_help_and_support(result)
    result << content_tag(:li, class: 'op-menu--item') do
      content_tag :span, I18n.t('top_menu.help_and_support'),
                  class: 'op-menu--headline',
                  title: I18n.t('top_menu.help_and_support')
    end
    if EnterpriseToken.show_banners?
      result << static_link_item(:upsale,
                                 href_suffix: "/?utm_source=unknown&utm_medium=op-instance&utm_campaign=ee-upsale-help-menu")
    end
    result << static_link_item(:user_guides)
    result << content_tag(:li, class: 'op-menu--item') do
      link_to I18n.t('label_videos'),
              ProyeksiApp::Configuration.youtube_channel,
              title: I18n.t('label_videos'),
              class: 'op-menu--item-action',
              target: '_blank'
    end
    result << static_link_item(:shortcuts)
    result << static_link_item(:forums)
    result << static_link_item(:professional_support)
    result << content_tag(:hr, '', class: 'op-menu--separator')
  end

  def render_additional_resources(result)
    result << content_tag(:li, class: 'op-menu--item') do
      content_tag :span,
                  I18n.t('top_menu.additional_resources'),
                  class: 'op-menu--headline',
                  title: I18n.t('top_menu.additional_resources')
    end

    if ProyeksiApp::Static::Links.has? :impressum
      result << static_link_item(:impressum)
    end

    result << static_link_item(:data_privacy)
    result << static_link_item(
      :website,
      href_suffix: "/?utm_source=unknown&utm_medium=op-instance&utm_campaign=website-help-menu"
    )
    result << static_link_item(
      :newsletter,
      href_suffix: "/?utm_source=unknown&utm_medium=op-instance&utm_campaign=newsletter-help-menu"
    )
    result << static_link_item(:blog)
    result << static_link_item(:release_notes)
    result << static_link_item(:report_bug)
    result << static_link_item(:roadmap)
    result << static_link_item(:crowdin)
    result << static_link_item(:api_docs)
  end

  def static_link_item(key, options = {})
    link = ProyeksiApp::Static::Links.links[key]
    label = I18n.t(link[:label])
    content_tag(:li, class: 'op-menu--item') do
      link_to label,
              "#{link[:href]}#{options[:href_suffix]}",
              title: label,
              target: '_blank',
              class: 'op-menu--item-action'
    end
  end
end
