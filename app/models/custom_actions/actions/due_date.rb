#-- encoding: UTF-8

class CustomActions::Actions::DueDate < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::DateProperty

  def self.key
    :due_date
  end
end
