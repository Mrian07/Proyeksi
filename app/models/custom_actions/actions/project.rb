#-- encoding: UTF-8



class CustomActions::Actions::Project < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::Associated

  PRIORITY = 10

  def self.key
    :project
  end

  def required?
    true
  end

  def priority
    PRIORITY
  end

  private

  def associated
    ::Project
      .select(:id, :name)
      .order(Arel.sql('LOWER(name)'))
      .map { |u| [u.id, u.name] }
  end
end
