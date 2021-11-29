#-- encoding: UTF-8



class Relations::CreateService < Relations::BaseService
  def initialize(user:)
    @user = user
    self.contract_class = Relations::CreateContract
  end

  def perform(relation, send_notifications: true)
    in_user_context(send_notifications) do
      update_relation relation, {}
    end
  end
end
