#-- encoding: UTF-8



require 'proyeksi_app/static/homescreen'
require 'proyeksi_app/static/links'

ProyeksiApp::Static::Homescreen.manage :blocks do |blocks|
  blocks.push(
    {
      partial: 'welcome',
      if: Proc.new { Setting.welcome_on_homescreen? && Setting.welcome_text.present? }
    },
    {
      partial: 'projects'
    },
    {
      partial: 'new_features',
      if: Proc.new { ProyeksiApp::Configuration.show_community_links? }
    },
    {
      partial: 'users',
      if: Proc.new { User.current.admin? }
    },
    {
      partial: 'my_account',
      if: Proc.new { User.current.logged? }
    },
    {
      partial: 'news',
      if: Proc.new { !@news.empty? }
    },
    {
      partial: 'community',
      if: Proc.new { EnterpriseToken.show_banners? || ProyeksiApp::Configuration.show_community_links? }
    },
    {
      partial: 'administration',
      if: Proc.new { User.current.admin? }
    },
    {
      partial: 'upsale',
      if: Proc.new { EnterpriseToken.show_banners? }
    }
  )
end

ProyeksiApp::Static::Homescreen.manage :links do |links|
  link_hash = ProyeksiApp::Static::Links.links

  links.push(
    {
      label: :user_guides,
      icon: 'icon-context icon-rename',
      url: link_hash[:user_guides][:href]
    },
    {
      label: :glossary,
      icon: 'icon-context icon-glossar',
      url: link_hash[:glossary][:href]
    },
    {
      label: :shortcuts,
      icon: 'icon-context icon-shortcuts',
      url: link_hash[:shortcuts][:href]
    },
    {
      label: :forums,
      icon: 'icon-context icon-forums',
      url: link_hash[:forums][:href]
    }
  )

  if impressum_link = link_hash[:impressum]
    links.push({
                 label: impressum_link[:label],
                 url: impressum_link[:href],
                 icon: 'icon-context icon-info1'
               })
  end
end
