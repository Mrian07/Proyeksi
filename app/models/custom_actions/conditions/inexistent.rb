#-- encoding: UTF-8



class CustomActions::Conditions::Inexistent < CustomActions::Conditions::Base
  def self.key
    :inexistent
  end

  def validate(errors)
    errors.add :conditions, :does_not_exist
  end
end
