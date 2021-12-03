#-- encoding: UTF-8

class Queries::Principals::Filters::StatusFilter < Queries::Principals::Filters::PrincipalFilter
  def allowed_values
    ::Principal.statuses.map do |key, value|
      [key, value]
    end
  end

  def type
    :list
  end

  def self.key
    :status
  end
end
