

class SCM::AuthorizationPolicy
  attr_reader :project, :user

  def initialize(project, user)
    @user = user
    @project = project
  end

  ##
  # Determines the authorization status for the user of this project
  # for a given repository request.
  # May be overridden by descendents when more than the read/write distinction
  # is necessary.
  def authorized?(params)
    (readonly_request?(params) && read_access?) || write_access?
  end

  protected

  ##
  # Determines whether the given request is a read access
  # Must be implemented by descendents of this policy.
  def readonly_request?(_params)
    raise NotImplementedError
  end

  ##
  # Returns whether the user has read access permission to the repository
  def read_access?
    user.allowed_to?(:browse_repository, project)
  end

  ##
  # Returns whether the user has read/write access permission to the repository
  def write_access?
    user.allowed_to?(:commit_access, project)
  end
end
