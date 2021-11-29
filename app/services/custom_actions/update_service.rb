#-- encoding: UTF-8



class CustomActions::UpdateService < CustomActions::BaseService
  attr_accessor :user,
                :action

  def initialize(action:, user:)
    self.action = action
    self.user = user
  end

  def call(attributes:, &block)
    super(attributes: attributes, action: action, &block)
  end
end
