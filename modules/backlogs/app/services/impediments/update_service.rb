

class Impediments::UpdateService
  attr_accessor :user, :impediment

  def initialize(user:, impediment:)
    self.user = user
    self.impediment = impediment
  end

  def call(attributes: {})
    WorkPackages::UpdateService
      .new(user: user,
           model: impediment)
      .call(**attributes)
  end
end
