#-- encoding: UTF-8



class CustomActions::Conditions::Status < CustomActions::Conditions::Base
  def self.key
    :status
  end

  private

  def associated
    ::Status
      .select(:id, :name)
      .order(:name)
      .map { |u| [u.id, u.name] }
  end
end
