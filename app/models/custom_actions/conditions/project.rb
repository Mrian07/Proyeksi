#-- encoding: UTF-8



class CustomActions::Conditions::Project < CustomActions::Conditions::Base
  def self.key
    :project
  end

  private

  def associated
    ::Project
      .active
      .select(:id, :name)
      .order(Arel.sql('LOWER(name)'))
      .map { |u| [u.id, u.name] }
  end
end
