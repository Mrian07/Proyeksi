#-- encoding: UTF-8



class CustomActions::Actions::Inexistent < CustomActions::Actions::Base
  def self.key
    :inexistent
  end

  def validate(errors)
    errors.add :actions, :does_not_exist
  end
end
