#-- encoding: UTF-8

class Queries::Principals::Filters::TypeFilter < Queries::Principals::Filters::PrincipalFilter
  def allowed_values
    [User, Group, PlaceholderUser]
      .map { |x| [x.to_s, x.to_s] }
  end

  def type
    :list
  end

  def self.key
    :type
  end

  def scope
    if operator == '='
      Principal.where(type: values)
    else
      Principal.where.not(type: values)
    end
  end
end
