#-- encoding: UTF-8



class Relations::UpdateService < Relations::BaseService
  attr_accessor :model

  def initialize(user:, model:)
    super(user: user)
    self.model = model
    self.contract_class = Relations::UpdateContract
  end

  def perform(attributes)
    in_context(attributes[:send_notifications]) do
      update_relation model, attributes
    end
  end
end
