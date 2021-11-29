#-- encoding: UTF-8



##
# Provides an asynchronous job to delete a managed repository on the filesystem.
# Currently, this is run synchronously due to potential issues
# with error handling.
# We envision a repository management wrapper that covers transactional
# creation and deletion of repositories BOTH on the database and filesystem.
# Until then, a synchronous process is more failsafe.
class SCM::DeleteLocalRepositoryJob < ApplicationJob
  def initialize(managed_path)
    @managed_path = managed_path
  end

  def perform
    # Delete the repository project itself.
    FileUtils.remove_dir(@managed_path)
  end

  def destroy_failed_jobs?
    true
  end
end
