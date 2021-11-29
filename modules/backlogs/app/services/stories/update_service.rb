

class Stories::UpdateService
  attr_accessor :user, :story

  def initialize(user:, story:)
    self.user = user
    self.story = story
  end

  def call(attributes: {}, prev: nil)
    create_call = WorkPackages::UpdateService
                  .new(user: user,
                       model: story)
                  .call(**attributes.symbolize_keys)

    if create_call.success? && prev
      create_call.result.move_after prev
    end

    create_call
  end
end
