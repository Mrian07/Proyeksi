#-- encoding: UTF-8



class CustomActions::Actions::EstimatedHours < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::Float

  def self.key
    :estimated_hours
  end

  def apply(work_package)
    work_package.estimated_hours = values.first
  end

  def minimum
    0
  end
end
