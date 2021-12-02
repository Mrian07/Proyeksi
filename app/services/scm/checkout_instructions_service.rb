#-- encoding: UTF-8



##
# Implements a repository service for building checkout instructions if supported
class SCM::CheckoutInstructionsService
  attr_reader :repository, :user, :path

  def initialize(repository, path: nil, user: User.current)
    @repository = repository
    @user = user
    @path = path
  end

  ##
  # Retrieve the checkout URL using the repository vendor information
  # It may additionally set a path parameter, if the repository supports subtree checkout
  def checkout_url(with_path = false)
    repository.scm.checkout_url(repository,
                                checkout_base_url,
                                with_path ? URI.escape(@path) : nil)
  end

  ##
  # Returns the checkout command from SCM adapter
  # (e.g., `git clone`)
  def checkout_command
    repository.scm.checkout_command
  end

  ##
  # Returns the checkout base URL as defined in settings.
  def checkout_base_url
    checkout_settings['base_url']
  end

  ##
  # Returns the instructions defined in the settings.
  def instructions
    checkout_settings['text'].presence ||
      I18n.t("repositories.checkout.default_instructions.#{repository.vendor}")
  end

  ##
  # Returns true when the checkout URL may target a subtree of the repository.
  def subtree_checkout?
    repository.scm.subtree_checkout?
  end

  ##
  # Determines whether the checkout URL may be built, i.e. all information is available
  # This is the case when the base_url is set or the vendor doesn't use base URLs.
  def checkout_url_buildable?
    !repository.class.requires_checkout_base_url? || checkout_base_url.present?
  end

  ##
  # Returns whether the repository supports showing checkout information
  # and has been configured for it.
  def available?
    checkout_enabled? &&
      repository.supports_checkout_info? &&
      checkout_url_buildable?
  end

  def checkout_enabled?
    checkout_settings['enabled'].to_i > 0
  end

  def supported_but_not_enabled?
    repository.supports_checkout_info? && !checkout_enabled?
  end

  ##
  # Determines whether permissions for the given repository
  # are available.
  def manages_permissions?
    repository.managed?
  end

  ##
  # Returns one of the following permission symbols for the given user
  #
  # - :readwrite: When user is allowed to read and commit (:commit_access)
  # - :read: When user is allowed to checkout the repository, but not commit (:browse_repository)
  # - :none: Otherwise
  #
  # Note that this information is only applicable when the repository is managed,
  # because otherwise ProyeksiApp does not control the repository permissions.
  # Use +manages_permissions?+ to check whether this is the case.
  #
  def permission
    project = repository.project
    if user.allowed_to?(:commit_access, project)
      :readwrite
    elsif user.allowed_to?(:browse_repository, project)
      :read
    else
      :none
    end
  end

  ##
  # Returns whether the given user may checkout the repository
  #
  # Note that this information is only applicable when the repository is managed,
  # because otherwise ProyeksiApp does not control the repository permissions.
  # Use +manages_permissions?+ to check whether this is the case.
  def may_checkout?
    %i[readwrite read].include?(permission)
  end

  ##
  # Returns whether the given user may commit to the repository
  #
  # Note that this information is only applicable when the repository is managed,
  # because otherwise ProyeksiApp does not control the repository permissions.
  # Use +manages_permissions?+ to check whether this is the case.
  def may_commit?
    permission == :readwrite
  end

  private

  def checkout_settings
    @settings ||= begin
      hash = Setting.repository_checkout_data[repository.vendor.to_s]
      hash.presence || {}
    end
  end
end
