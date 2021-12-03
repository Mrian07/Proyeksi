#-- encoding: UTF-8

class CustomActions::Actions::StartDate < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::DateProperty

  def self.key
    :start_date
  end
end
