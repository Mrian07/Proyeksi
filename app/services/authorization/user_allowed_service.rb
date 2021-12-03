#-- encoding: UTF-8

class Authorization::UserAllowedService
  attr_accessor :user

  def initialize(user, role_cache: Users::ProjectRoleCache.new(user))
    self.user = user
    self.project_role_cache = role_cache
  end

  # Return true if the user is allowed to do the specified action on a specific context
  # Action can be:
  # * a parameter-like Hash (eg. controller: '/projects', action: 'edit')
  # * a permission Symbol (eg. :edit_project)
  # Context can be:
  # * a project : returns true if user is allowed to do the specified action on this project
  # * a group of projects : returns true if user is allowed on every project
  # * nil with options[:global] set : check if user has at least one role allowed for this action,
  #   or falls back to Non Member / Anonymous permissions depending if the user is logged
  def call(action, context, options = {})
    if supported_context?(context, options)
      ServiceResult.new(success: true,
                        result: allowed_to?(action, context, options))
    else
      ServiceResult.new(success: false,
                        result: false)
    end
  end

  def preload_projects_allowed_to(action)
    project_authorization_cache.cache(action)
  end

  private

  attr_accessor :project_role_cache

  def allowed_to?(action, context, options = {})
    action = normalize_action(action)

    if context.nil? && options[:global]
      allowed_to_globally?(action, options)
    elsif context.is_a? Project
      allowed_to_in_project?(action, context, options)
    elsif context.respond_to?(:to_a)
      context = context.to_a
      # Authorize if user is authorized on every element of the array
      context.present? && context.all? do |project|
        allowed_to?(action, project, options)
      end
    else
      false
    end
  end

  def allowed_to_in_project?(action, project, _options = {})
    if project_authorization_cache.cached?(action)
      return project_authorization_cache.allowed?(action, project)
    end

    # No action allowed on archived projects
    return false unless project.active?
    # No action allowed on disabled modules
    return false unless project.allows_to?(action)
    # Inactive users are never authorized
    return false unless authorizable_user?
    # Admin users are authorized for anything else
    return true if user.admin?

    has_authorized_role?(action, project)
  end

  # Is the user allowed to do the specified action on any project?
  # See allowed_to? for the actions and valid options.
  def allowed_to_globally?(action, _options = {})
    # Inactive users are never authorized
    return false unless authorizable_user?
    # Admin users are always authorized
    return true if user.admin?

    has_authorized_role?(action)
  end

  ##
  # Only users that are not locked may be granted actions
  # with the exception of a temporary-granted system user
  def authorizable_user?
    !user.locked? || user.is_a?(SystemUser)
  end

  def has_authorized_role?(action, project = nil)
    project_role_cache
      .fetch(project)
      .any? do |role|
      role.allowed_to?(action)
    end
  end

  def project_authorization_cache
    @project_authorization_cache ||= Users::ProjectAuthorizationCache.new(user)
  end

  def normalize_action(action)
    if action.is_a?(Hash) && action[:controller] && action[:controller].to_s.starts_with?('/')
      action = action.dup
      action[:controller] = action[:controller][1..-1]
    end

    action
  end

  def supported_context?(context, options)
    (context.nil? && options[:global]) ||
      context.is_a?(Project) ||
      (!context.nil? && context.respond_to?(:to_a))
  end
end
