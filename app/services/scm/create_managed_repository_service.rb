#-- encoding: UTF-8

##
# Implements the creation of a local repository.
class SCM::CreateManagedRepositoryService < SCM::BaseRepositoryService
  ##
  # Checks if a given repository may be created and managed locally.
  # Registers an job to create the repository on disk.
  #
  # @return True if the repository creation request has been initiated, false otherwise.
  def call
    if repository.managed? && repository.manageable?

      ##
      # We want to move this functionality in a Delayed Job,
      # but this heavily interferes with the error handling of the whole
      # repository management process.
      # Instead, this will be refactored into a single service wrapper for
      # creating and deleting repositories, which provides transactional DB access
      # as well as filesystem access.
      if repository.class.manages_remote?
        SCM::CreateRemoteRepositoryJob.perform_now(repository)
      else
        SCM::CreateLocalRepositoryJob.ensure_not_existing!(repository)
        SCM::CreateLocalRepositoryJob.perform_later(repository)
      end
      return true
    end

    false
  rescue Errno::EACCES
    @rejected = I18n.t('repositories.errors.path_permission_failed',
                       path: repository.root_url)
    false
  rescue SystemCallError => e
    @rejected = I18n.t('repositories.errors.filesystem_access_failed',
                       message: e.message)
    false
  rescue ProyeksiApp::SCM::Exceptions::SCMError => e
    @rejected = e.message
    false
  end

  ##
  # Returns the error symbol
  def localized_rejected_reason
    @rejected ||= I18n.t('repositories.errors.not_manageable')
  end
end
