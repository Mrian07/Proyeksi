#-- encoding: UTF-8



class CustomActions::Actions::Date < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::Date

  def self.key
    :date
  end

  def apply(work_package)
    work_package.start_date = date_to_apply
    work_package.due_date = date_to_apply
  end
end
