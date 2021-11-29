

module VersionsHelper
  # Returns a set of options for a select field, grouped by project.
  def version_options_for_select(versions, selected = nil)
    grouped = versions_by_project((versions + [selected]).compact)

    if grouped.size > 1
      grouped_options_for_select(grouped, selected&.id)
    else
      options_for_select((grouped.values.first || []), selected&.id)
    end
  end

  def link_to_version(version, html_options = {}, options = {})
    return '' unless version&.is_a?(Version)

    html_options = html_options.merge(id: link_to_version_id(version))

    link_name = options[:before_text].to_s.html_safe + format_version_name(version, options[:project] || @project)
    link_to_if version.visible?,
               link_name,
               { controller: '/versions', action: 'show', id: version },
               html_options
  end

  def link_to_version_id(version)
    ERB::Util.url_encode("version-#{version.name}")
  end

  def format_version_name(version, project = @project)
    h(version.to_s_for_project(project))
  end

  def version_contract(version)
    if version.new_record?
      Versions::CreateContract.new(version, User.current)
    else
      Versions::UpdateContract.new(version, User.current)
    end
  end

  def format_version_sharing(sharing)
    sharing = 'none' unless Version::VERSION_SHARINGS.include?(sharing)
    t("label_version_sharing_#{sharing}")
  end

  def versions_by_project(versions)
    versions.uniq.inject(Hash.new { |h, k| h[k] = [] }) do |hash, version|
      hash[version.project.name] << [version.name, version.id]
      hash
    end
  end
end
