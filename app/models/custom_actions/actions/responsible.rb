class CustomActions::Actions::Responsible < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::Associated

  def associated
    User
      .not_locked
      .select(:id, :firstname, :lastname, :type)
      .ordered_by_name
      .map { |u| [u.id, u.name] }
  end

  def required?
    false
  end

  def self.key
    :responsible
  end
end
