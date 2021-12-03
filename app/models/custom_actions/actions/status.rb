#-- encoding: UTF-8

class CustomActions::Actions::Status < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::Associated

  def self.key
    :status
  end

  def required?
    true
  end

  private

  def associated
    Status
      .select(:id, :name)
      .order(:name)
      .map { |u| [u.id, u.name] }
  end
end
