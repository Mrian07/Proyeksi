#-- encoding: UTF-8

# project, projects, global, user = nil

class AuthorizationService
  # @params
  #   ctrl - controller
  #   action - action
  # @named params
  #   context - single project or array of projects - default nil
  #   global - global - default false
  #   user - user - default current user
  def initialize(permission, context: nil, global: false, user: User.current)
    @permission = permission
    @context = context
    @global = global
    @user = user
  end

  def call
    @user.allowed_to?(@permission, @context, global: @global)
  end
end
