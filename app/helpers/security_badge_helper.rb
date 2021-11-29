#-- encoding: UTF-8



module SecurityBadgeHelper
  def security_badge_url(args = {})
    uri = URI.parse(OpenProject::Configuration[:security_badge_url])
    info = {
      uuid: Setting.installation_uuid,
      type: OpenProject::Configuration[:installation_type],
      version: OpenProject::VERSION.to_semver,
      db: ActiveRecord::Base.connection.adapter_name.downcase,
      lang: User.current.try(:language),
      ee: EnterpriseToken.current.present?
    }.merge(args.symbolize_keys)
    uri.query = info.to_query
    uri.to_s
  end

  def display_security_badge_graphic?
    OpenProject::Configuration.security_badge_displayed? && Setting.security_badge_displayed?
  end
end
