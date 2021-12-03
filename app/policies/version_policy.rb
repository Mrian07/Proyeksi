class VersionPolicy < BasePolicy
  private

  def cache(version)
    @cache ||= Hash.new do |hash, cached_version|
      hash[cached_version] = {
        show: show_allowed?(cached_version)
      }
    end

    @cache[version]
  end

  def show_allowed?(version)
    @show_cache ||= Hash.new do |hash, queried_version|
      permissions = %i[view_work_packages manage_versions]

      hash[queried_version] = permissions.any? do |permission|
        queried_version.projects.allowed_to(user, permission).exists?
      end
    end

    @show_cache[version]
  end
end
