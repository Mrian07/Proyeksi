#-- encoding: UTF-8



module API
  module V3
    module JobStatus
      class JobStatusRepresenter < ::API::Decorators::Single
        self_link id_attribute: :job_id,
                  title_getter: ->(*) { nil }

        property :job_id

        property :status

        property :message,
                 render_nil: true

        property :payload,
                 render_nil: true

        def _type
          'JobStatus'
        end
      end
    end
  end
end
