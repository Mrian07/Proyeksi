class BasePolicy
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def actions(wp)
    cache[wp].each_with_object([]) { |(k, v), a| a << k if v }
  end

  def allowed?(object, action)
    cache(object)[action]
  end
end
