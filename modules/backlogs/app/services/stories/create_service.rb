

class Stories::CreateService
  attr_accessor :user

  def initialize(user:)
    self.user = user
  end

  def call(attributes: {}, prev: nil)
    create_call = WorkPackages::CreateService
                  .new(user: user)
                  .call(**attributes.symbolize_keys)

    if create_call.success?
      create_call.result.move_after prev
    end

    create_call
  end
end
