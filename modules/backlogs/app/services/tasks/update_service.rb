

class Tasks::UpdateService
  attr_accessor :user, :task

  def initialize(user:, task:)
    self.user = user
    self.task = task
  end

  def call(attributes: {}, prev: '')
    create_call = WorkPackages::UpdateService
                  .new(user: user,
                       model: task)
                  .call(**attributes)

    if create_call.success?
      create_call.result.move_after prev
    end

    create_call
  end
end
