#-- encoding: UTF-8



class CustomActions::Conditions::Type < CustomActions::Conditions::Base
  def self.key
    :type
  end

  private

  def associated
    ::Type
      .select(:id, :name)
      .map { |u| [u.id, u.name] }
  end
end
