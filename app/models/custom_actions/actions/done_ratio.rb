#-- encoding: UTF-8

class CustomActions::Actions::DoneRatio < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::Integer

  def self.key
    :done_ratio
  end

  def apply(work_package)
    work_package.done_ratio = values.first
  end

  def minimum
    0
  end

  def maximum
    100
  end

  def self.all
    if WorkPackage.use_field_for_done_ratio?
      super
    else
      []
    end
  end
end
