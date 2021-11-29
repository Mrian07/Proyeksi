#-- encoding: UTF-8


module JobStatus
  module ApplicationJobWithStatus
    # Delayed jobs can have a status:
    # Delayed::Job::Status
    # which is related to the job via a reference which is an AR model instance.
    def status_reference
      nil
    end

    ##
    # Determine whether to store a status object for this job
    # By default, will only store if status_reference is present
    def store_status?
      !status_reference.nil?
    end

    ##
    # For more complex handling of status updates
    # jobs can do success messages themselves.
    #
    # In case of exceptions being caught by activejob
    # the status will be modified outside.
    def updates_own_status?
      false
    end

    ##
    # Get the current status object, if any
    def job_status
      ::JobStatus::Status
        .find_by(job_id: job_id)
    end

    ##
    # Update the status code for a given job
    def upsert_status(status:, **args)
      # Can't use upsert, as we only want to insert the user_id once
      # and not update it repeatedly
      resource = ::JobStatus::Status.find_or_initialize_by(job_id: job_id)

      if resource.new_record?
        resource.user = User.current # needed so `resource.user` works below
        resource.user_id = User.current.id
        resource.reference = status_reference
      end

      # Update properties with the language of the user
      # to ensure things like the title are correct
      OpenProject::LocaleHelper.with_locale_for(resource.user) do
        resource.attributes = build_status_attributes(args.merge(status: status))
      end

      resource.save!
    end

    protected

    ##
    # Builds the attributes for updating the status
    def build_status_attributes(attributes)
      if title
        attributes[:payload] ||= {}
        attributes[:payload][:title] = title
      end

      attributes.reverse_merge(message: nil, payload: nil)
    end

    ##
    # Title of the job status, optional
    def title
      nil
    end

    ##
    # Crafts a payload for a redirection result
    def redirect_payload(path)
      { redirect: path }
    end

    ##
    # Crafts a payload for a download result
    def download_payload(path)
      { download: path }
    end
  end
end
