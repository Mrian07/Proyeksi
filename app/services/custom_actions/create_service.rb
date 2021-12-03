#-- encoding: UTF-8

class CustomActions::CreateService < CustomActions::BaseService
  def initialize(user:)
    self.user = user
  end

  def call(attributes:,
           action: CustomAction.new,
           &block)
    super
  end
end
