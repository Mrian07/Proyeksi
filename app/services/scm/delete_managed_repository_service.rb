#-- encoding: UTF-8



##
# Implements the asynchronous deletion of a local repository.
class SCM::DeleteManagedRepositoryService < SCM::BaseRepositoryService
  ##
  # Checks if a given repository may be deleted
  # Registers an asynchronous job to delete the repository on disk.
  #
  def call
    return false unless repository.managed?

    if repository.class.manages_remote?
      SCM::DeleteRemoteRepositoryJob.perform_now(repository)
      true
    else
      delete_local_repository
    end
  rescue OpenProject::SCM::Exceptions::SCMError => e
    @rejected = e.message
    false
  end

  def delete_local_repository
    # Create necessary changes to repository to mark
    # it as managed by OP, but delete asynchronously.
    managed_path = repository.root_url

    if File.directory?(managed_path)
      ##
      # We want to move this functionality in a Delayed Job,
      # but this heavily interferes with the error handling of the whole
      # repository management process.
      # Instead, this will be refactored into a single service wrapper for
      # creating and deleting repositories, which provides transactional DB access
      # as well as filesystem access.
      SCM::DeleteLocalRepositoryJob.perform_now(managed_path)
    end

    true
  rescue SystemCallError => e
    @rejected = I18n.t('repositories.errors.managed_delete_local',
                       path: repository.root_url,
                       error_message: e.message)
    false
  end

  ##
  # Returns the error symbol
  def localized_rejected_reason
    @rejected ||= I18n.t('repositories.errors.managed_delete')
  end
end
