#-- encoding: UTF-8

class Queries::WorkPackages::Filter::AuthorFilter <
  Queries::WorkPackages::Filter::PrincipalBaseFilter
  def allowed_values
    @author_values ||= begin
                         me_allowed_value + principal_loader.user_values
                       end
  end

  def type
    :list
  end

  def self.key
    :author_id
  end
end
