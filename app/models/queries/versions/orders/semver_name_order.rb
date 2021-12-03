#-- encoding: UTF-8

class Queries::Versions::Orders::SemverNameOrder < Queries::Orders::Base
  self.model = Version

  def self.key
    :semver_name
  end

  private

  def order
    ordered = Version.order_by_semver_name

    if direction == :desc
      ordered = ordered.reverse_order
    end

    ordered
  end
end
