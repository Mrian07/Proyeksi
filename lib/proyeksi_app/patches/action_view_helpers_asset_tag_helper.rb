#-- encoding: UTF-8



module ProyeksiApp::Patches::ActionViewHelpersAssetTagHelperPatch
  def auto_discovery_link_tag(type = :rss, url_options = {}, tag_options = {})
    return if (type == :atom) && Setting.table_exists? && !Setting.feeds_enabled?

    super
  end
end

ActionView::Helpers::AssetTagHelper.prepend(ProyeksiApp::Patches::ActionViewHelpersAssetTagHelperPatch)
