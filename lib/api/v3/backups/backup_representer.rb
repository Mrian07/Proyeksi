

module API
  module V3
    module Backups
      class BackupRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Caching::CachedRepresenter

        property :job_status_id, getter: ->(*) { job_status.job_id }

        link :job_status do
          {
            title: "Backup job status",
            href: api_v3_paths.job_status(represented.job_status.job_id)
          }
        end

        def _type
          'Backup'
        end
      end
    end
  end
end
