#-- encoding: UTF-8



class Queries::Versions::Filters::SharingFilter < Queries::Versions::Filters::VersionFilter
  def allowed_values
    Version::VERSION_SHARINGS.map do |name|
      [I18n.t(:"label_version_sharing_#{name}"), name]
    end
  end

  def type
    :list
  end

  def self.key
    :sharing
  end
end
