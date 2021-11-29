

class Impediments::CreateService
  attr_accessor :user

  def initialize(user:)
    self.user = user
  end

  def call(attributes: {})
    attributes[:type_id] = Impediment.type

    WorkPackages::CreateService
      .new(user: user)
      .call(**attributes.merge(work_package: Impediment.new).symbolize_keys)
  end
end
