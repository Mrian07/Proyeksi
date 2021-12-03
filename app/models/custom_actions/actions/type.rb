#-- encoding: UTF-8

class CustomActions::Actions::Type < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::Associated

  PRIORITY = 20

  def self.key
    :type
  end

  def required?
    true
  end

  def priority
    PRIORITY
  end

  private

  def associated
    ::Type
      .select(:id, :name)
      .order(:position)
      .map { |u| [u.id, u.name] }
  end
end
