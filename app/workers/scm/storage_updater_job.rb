#-- encoding: UTF-8



class SCM::StorageUpdaterJob < ApplicationJob
  queue_with_priority :low

  def perform(repository)
    unless repository.scm.storage_available?
      Rails.logger.warn "Storage is not available for repository #{repository.id}"
      return
    end

    bytes = repository.scm.count_repository!

    repository.update!(
      required_storage_bytes: bytes,
      storage_updated_at: Time.now
    )
  end

  ##
  # We don't want to repeat failing jobs here,
  # as they might have failed due to I/O problems and thus,
  # we rather keep the old outdated value until an event
  # triggers the update again.
  def max_attempts
    1
  end
end
