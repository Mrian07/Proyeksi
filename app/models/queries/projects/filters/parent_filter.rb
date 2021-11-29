#-- encoding: UTF-8



class Queries::Projects::Filters::ParentFilter < Queries::Projects::Filters::ProjectFilter
  def type
    :list_optional
  end

  def self.key
    :parent_id
  end

  def allowed_values
    @allowed_values ||= begin
      ::Project.visible.pluck(:id).map { |id| [id, id.to_s] }
    end
  end
end
