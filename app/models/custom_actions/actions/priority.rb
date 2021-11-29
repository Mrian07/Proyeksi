#-- encoding: UTF-8



class CustomActions::Actions::Priority < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::Associated

  def associated
    IssuePriority
      .select(:id, :name)
      .order(:name)
      .map { |p| [p.id, p.name] }
  end

  def required?
    true
  end

  def self.key
    :priority
  end
end
