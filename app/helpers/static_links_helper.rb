#-- encoding: UTF-8



module StaticLinksHelper
  ##
  # Create a static link to the given key entry
  def static_link_to(key, label: nil)
    item = ProyeksiApp::Static::Links.links.fetch key

    link_to label || t(item[:label]),
            item[:href],
            class: 'proyeksiapp--static-link',
            target: '_blank'
  end
end
